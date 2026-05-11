#!/usr/bin/env bash

set -euo pipefail

if ! command -v aws >/dev/null 2>&1; then
  echo "aws CLI is required" >&2
  exit 1
fi

STATE_BUCKET=${STATE_BUCKET:-future20-terraform-state}
LOCK_TABLE=${LOCK_TABLE:-future20-terraform-locks}
S3_ENDPOINT=${S3_ENDPOINT:-https://storage.yandexcloud.net}
DYNAMODB_ENDPOINT=${DYNAMODB_ENDPOINT:-https://docapi.serverless.yandexcloud.net}
AWS_REGION=${AWS_REGION:-ru-central1}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_ROOT="${ROOT_DIR}/envs"

require_vars=("YC_ACCESS_KEY_ID" "YC_SECRET_ACCESS_KEY")
for var in "${require_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "Environment variable ${var} must be set" >&2
    exit 1
  fi
done

ensure_bucket() {
  if aws s3api head-bucket --bucket "${STATE_BUCKET}" --endpoint-url "${S3_ENDPOINT}" >/dev/null 2>&1; then
    echo "Bucket ${STATE_BUCKET} already exists"
    return
  fi

  echo "Creating bucket ${STATE_BUCKET}"
  aws s3api create-bucket \
    --bucket "${STATE_BUCKET}" \
    --create-bucket-configuration LocationConstraint="${AWS_REGION}" \
    --endpoint-url "${S3_ENDPOINT}" \
    --region "${AWS_REGION}"

  aws s3api put-bucket-versioning \
    --bucket "${STATE_BUCKET}" \
    --versioning-configuration Status=Enabled \
    --endpoint-url "${S3_ENDPOINT}"

  aws s3api put-bucket-encryption \
    --bucket "${STATE_BUCKET}" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' \
    --endpoint-url "${S3_ENDPOINT}"
}

ensure_lock_table() {
  if aws dynamodb describe-table \
    --table-name "${LOCK_TABLE}" \
    --endpoint-url "${DYNAMODB_ENDPOINT}" \
    --region "${AWS_REGION}" >/dev/null 2>&1; then
    echo "DynamoDB table ${LOCK_TABLE} already exists"
    return
  fi

  echo "Creating lock table ${LOCK_TABLE}"
  aws dynamodb create-table \
    --table-name "${LOCK_TABLE}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url "${DYNAMODB_ENDPOINT}" \
    --region "${AWS_REGION}"
}

init_environment() {
  local env_name="$1"
  pushd "${ENV_ROOT}/${env_name}" >/dev/null
  terraform init \
    -backend-config="bucket=${STATE_BUCKET}" \
    -backend-config="endpoint=${S3_ENDPOINT}" \
    -backend-config="region=${AWS_REGION}" \
    -backend-config="dynamodb_table=${LOCK_TABLE}" \
    -backend-config="skip_credentials_validation=true" \
    -backend-config="skip_region_validation=true" \
    -backend-config="skip_metadata_api_check=true" \
    -backend-config="force_path_style=true"
  popd >/dev/null
}

ensure_bucket
ensure_lock_table

for environment in dev stage prod; do
  echo "Running terraform init for ${environment}"
  init_environment "${environment}"
done

echo "Backend configuration finished"
