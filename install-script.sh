#!/bin/bash

read -p "Please enter your email address: " email
read -p "Please enter desired username: " username
read -sp "Please enter desired password (at least 8 characters and 1 number): " password
printf '\n-------------------\n'
#oc new-project quay-ecosystem
oc project user2
oc create secret generic redhat-pull-secret \
  --from-file=".dockerconfigjson=$XDG_RUNTIME_DIR/containers/auth.json" \
  --type='kubernetes.io/dockerconfigjson'
oc create secret generic quay-database-credential \
  --from-literal=database-username="$username" \
  --from-literal=database-password="$password" \
  --from-literal=database-root-password="$pasword" \
  --from-literal=database-name=quay-enterprise
oc create secret generic quay-super-user \
  --from-literal=superuser-username="$username" \
  --from-literal=superuser-password="$password" \
  --from-literal=superuser-email="$email"
oc create secret generic quay-config-app \
  --from-literal=config-app-password="$password"
oc create secret generic quay-redis-password \
  --from-literal=password="$password"
sleep 5
oc create -f advanced_config_example.yaml