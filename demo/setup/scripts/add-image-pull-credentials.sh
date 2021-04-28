#!/usr/bin/env bash
set -eo pipefail
read -p "Docker registry credential name (used for secret object name): " CRED_NAME
read -p "Service acount to patch: " SERVICE_ACCOUNT
read -p "Docker Registry Server (Example: ghcr.io, docker.io, harbor.mycluster.com): " DOCKER_REGISTRY_SERVER
read -p "Docker Registry Username : " DOCKER_USER
read -p "Docker Registry User Email : " DOCKER_EMAIL
read -s -p "Docker Registry Password : " DOCKER_PASSWORD

if [ $CRED_NAME != "" ]
then
echo "Creating $CRED_NAME for docker registry $DOCKER_REGISTRY_SERVER"
    kubectl create secret docker-registry $CRED_NAME \
        --docker-server=$DOCKER_REGISTRY_SERVER \
        --docker-username=$DOCKER_USER \
        --docker-password=$DOCKER_PASSWORD \
        --docker-email=$DOCKER_EMAIL
fi

TMP_FILE=/tmp/img-pull.json

kubectl get secrets --field-selector type=kubernetes.io/dockerconfigjson -o custom-columns=NAME:.metadata.name --no-headers   | sed 's/^/{"name": "/;s/$/"}/' > $TMP_FILE
imagePullSecrets=$(readarray -t creds < $TMP_FILE; IFS=','; echo "${creds[*]}")
rm $TMP_FILE
patch="{\"imagePullSecrets\": [ $imagePullSecrets ]}"
kubectl patch serviceaccount $SERVICE_ACCOUNT -p "$patch"

