#!/bin/bash
#
# Please rename this file to make-sealedsecret.sh
# Requires sealedSecrets installed on the cluster and kubeseal installed locally.
#
ENV=<my-environment>
NAME="postgres-users"
PASSWORD="mypassword"
POSTGRES_PASSWORD="postgres"
FILE="${ENV}-postgres-users.yaml"
PUBLIC_KEY_FILENAME="${ENV}_public_key.pem"

curl https://sealed-secrets.<cluster-address>/v1/cert.pem > ${PUBLIC_KEY_FILENAME}


kubectl create secret generic "${NAME}" \
	--dry-run=client \
	--from-literal=password="${PASSWORD}" \
	--from-literal=postgres-password="${POSTGRES_PASSWORD}" \
	-o yaml | \
    kubeseal \
      --cert ${PUBLIC_KEY_FILENAME} \
      --scope cluster-wide \
      --format yaml > "${FILE}"
