#!/bin/bash

#!/bin/bash

for i in 18
do 
oc project user$i
cat <<EOF | oc delete -f -
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

cat <<EOF | oc delete -f -
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
done