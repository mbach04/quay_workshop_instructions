#!/bin/bash

i=20
 
#oc new-project user$i
for i in {1..15}
do
cat <<EOF | oc apply -f -
---
apiVersion: v1
kind: Namespace
metadata:
  labels:
    openshift.io/cluster-monitoring: "true"
  name: user$i
spec: {}
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: quay-enterprise-operatorgroup
  namespace: user$i
spec:
  targetNamespaces:
  - user$i
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: quay-operator
  namespace: user$i
spec:
  channel: quay-v3.3
  installPlanApproval: Automatic
  name: quay-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF
#Create secrets for quay etc
oc project user$i
oc create secret generic redhat-pull-secret \
  --from-file=".dockerconfigjson=$XDG_RUNTIME_DIR/containers/auth.json" \
  --type='kubernetes.io/dockerconfigjson'
oc create secret generic quay-database-credential \
  --from-literal=database-username="mbach" \
  --from-literal=database-password="openshift" \
  --from-literal=database-root-password="openshift" \
  --from-literal=database-name=quay-enterprise
oc create secret generic quay-super-user \
  --from-literal=superuser-username="mbach" \
  --from-literal=superuser-password="openshift" \
  --from-literal=superuser-email="mbach@redhat.com"
oc create secret generic quay-config-app \
  --from-literal=config-app-password="openshift"
oc create secret generic quay-redis-password \
  --from-literal=password="openshift"
sleep 5

cat <<EOF | oc apply -f -
apiVersion: redhatcop.redhat.io/v1alpha1
kind: QuayEcosystem
metadata:
  name: quayecosystem-user$i
spec:
  quay:
    enableRepoMirroring: true
    imagePullSecretName: redhat-pull-secret
    superuserCredentialsSecretName: quay-super-user
    configSecretName: quay-config-app
  clair:
    enabled: true
    imagePullSecretName: redhat-pull-secret
    updateInterval: "60m"
  redis:
    credentialsSecretName: quay-redis-password
    imagePullSecretName: redhat-pull-secret
EOF
done