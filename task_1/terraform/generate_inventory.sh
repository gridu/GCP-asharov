#!/usr/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INVENTORY_FILE="${SCRIPT_DIR}/../ansible/inventory"

SSH_KEY_PATH="${1}"

ADDRESSES=$(gcloud compute instances list --filter='name ~ dev-http*' \
    --flatten networkInterfaces[].accessConfigs[] \
    --format 'csv[no-heading](networkInterfaces.accessConfigs.natIP)')

echo "[dev-httpd]" > "${INVENTORY_FILE}"

for ADDRESS in ${ADDRESSES}; do
  echo "infra@${ADDRESS} ansible_host=${ADDRESS} ansible_ssh_private_key_file=${SSH_KEY_PATH} ansible_user=infra ansible_connection=ssh" >> "${INVENTORY_FILE}"
done
