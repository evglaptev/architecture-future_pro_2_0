# architecture-future_pro_2_0

Sprint 11

## Запуск

### Task1Advanced
1. Выбрать нужное окружение: `cd Task1Advanced/envs/<dev|stage|prod>`.
2. Заполнить `terraform.tfvars` (token, cloud/folder/subnet, `vm_profile`).
3. Выполнить:
   ```bash
   terraform init
   terraform plan  -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"
   ```
   При сворачивании: `terraform destroy -var-file="terraform.tfvars"`.

### Task2Advanced
1. Настройте репозиторные Secrets/Variables GitHub (`YC_ACCESS_KEY_ID`, `YC_SECRET_ACCESS_KEY`, `YANDEX_TOKEN`, `YC_CLOUD_ID`, `YC_FOLDER_ID`, `YC_SUBNET_ID`, `SSH_PUBLIC_KEY`, а также `STATE_BUCKET`, `LOCK_TABLE`, `S3_ENDPOINT`, `AWS_REGION`).
2. Локально можно переиспользовать окружения Task2Advanced так же, как в Task1, но backend уже указывает на S3. Команды:
   ```bash
   cd Task2Advanced/envs/<dev|stage|prod>
   terraform init \
     -backend-config="bucket=${STATE_BUCKET}" \
     -backend-config="endpoint=${S3_ENDPOINT}" \
     -backend-config="region=${AWS_REGION}" \
     -backend-config="dynamodb_table=${LOCK_TABLE}" \
     -backend-config="skip_credentials_validation=true" \
     -backend-config="skip_region_validation=true" \
     -backend-config="skip_metadata_api_check=true" \
     -backend-config="force_path_style=true"
   terraform plan  -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"
   ```
3. В CI/CD используйте workflow `terraform-plan` (авто на push/PR) и `terraform-apply` (ручной запуск с выбором окружения). Перед запуском можно проверить секреты: `Task2Advanced/scripts/validate-secrets.sh`. Для настройки бакета/таблицы вызовите `Task2Advanced/scripts/setup-backend.sh`.
