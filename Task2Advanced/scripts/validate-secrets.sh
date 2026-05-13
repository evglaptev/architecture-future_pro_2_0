#!/usr/bin/env bash

set -euo pipefail

REQUIRED_VARS=${REQUIRED_VARS:-"YC_ACCESS_KEY_ID YC_SECRET_ACCESS_KEY TF_VAR_yandex_token TF_VAR_cloud_id TF_VAR_folder_id TF_VAR_subnet_id TF_VAR_ssh_public_key"}

missing=()
for var in ${REQUIRED_VARS}; do
  if [[ -z "${!var:-}" ]]; then
    missing+=("$var")
  fi
done

if ((${#missing[@]} > 0)); then
  echo "Missing secrets:"
  for item in "${missing[@]}"; do
    echo "  - ${item}"
  done
  exit 1
fi

echo "Required secrets are present"
