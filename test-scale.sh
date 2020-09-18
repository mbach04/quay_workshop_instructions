#!/bin/bash

for i in {3..4}
do
#Install the Quay Operator
oc new-project user$i
cat <<EOF | oc apply -f -
# Base namespace for creation of operator
# ---
# apiVersion: v1
# kind: Namespace
# metadata:
#   labels:
#     openshift.io/cluster-monitoring: "true"
#   name: user$i
# spec: {}
# OperatorGroup for OLM configuration
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: quay-enterprise-operatorgroup
  namespace: user$i
spec:
  targetNamespaces:
  - user$i
# Subscription to trigger OLM installation
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
# Secret required to pull from quay.io
---
apiVersion: v1
kind: Secret
metadata:
  name: redhat-pull-secret
  namespace: user$i
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ewogICJhdXRocyI6IHsKICAgICJxdWF5LmlvIjogewogICAgICAiYXV0aCI6ICJjbVZrYUdGMEszRjFZWGs2VHpneFYxTklVbE5LVWpFMFZVRmFRa3MxTkVkUlNFcFRNRkF4VmpSRFRGZEJTbFl4V0RKRE5GTkVOMHRQTlRsRFVUbE9NMUpGTVRJMk1USllWVEZJVWc9PSIsCiAgICAgICJlbWFpbCI6ICIiCiAgICB9CiAgfQp9
EOF

# oc project user$i
sleep 5
#Create secrets for quay, redis, postgres
cat <<EOF | oc apply -f -
# Secret to change default password for super-user
---
apiVersion: v1
kind: Secret
metadata:
  name: quay-superuser
  namespace: user$i
type: Opaque
stringData:
  superuser-username: quay
  superuser-password: openshift
  superuser-email: quay@redhat.com
---
apiVersion: v1
kind: Secret
metadata:
  name: quay-database-credential
  namespace: user$i
type: Opaque
stringData:
  database-username: quay
  database-password: openshift
  database-root-password: openshift
  database-name: quay-enterprise
---
apiVersion: v1
kind: Secret
metadata:
  name: quay-config-app
  namespace: user$i
type: Opaque
stringData:
  config-app-password: openshift
---
apiVersion: v1
kind: Secret
metadata:
  name: quay-redis-password
  namespace: user$i
type: Opaque
stringData:
  password: openshift
EOF
sleep 45
#Launch an instance of Quay
cat <<EOF | oc apply -f -
apiVersion: redhatcop.redhat.io/v1alpha1
kind: QuayEcosystem
metadata:
  name: quayecosystem-user$i
  namespace: user$i
spec:
  quay:
    enableRepoMirroring: true
    imagePullSecretName: redhat-pull-secret
    superuserCredentialsSecretName: quay-superuser
    configSecretName: quay-config-app
    database:
      volumeSize: 10Gi
    registryStorage:
      persistentVolumeSize: 10Gi
      persistentVolumeAccessModes:
        - ReadWriteOnce
  clair:
    enabled: true
    imagePullSecretName: redhat-pull-secret
    updateInterval: "60m"
  redis:
    credentialsSecretName: quay-redis-password
    imagePullSecretName: redhat-pull-secret
EOF
done