# CI/CD для Terraform c удалённым состоянием

Task2Advanced переиспользует модуль виртуальной машины из `Task1Advanced` и добавляет инфраструктурный пайплайн: состояние хранится в S3-совместимом Object Storage, блокировки обеспечиваются через совместимый DynamoDB API, а все операции выполняются из GitHub Actions.

## Структура директории

```
Task2Advanced
├── envs/                 # Самодостаточные окружения dev/stage/prod
│   └── <env>/            # backend + провайдер + вызов модуля из Task1Advanced
├── scripts/
│   ├── setup-backend.sh  # Создание бакета/таблицы и массовый terraform init
│   └── validate-secrets.sh
└── .github/workflows/
    ├── terraform-plan.yml     # Plan для всех окружений
    ├── terraform-apply.yml    # Ручной запуск с approval
    └── terraform-security.yml # tfsec + Checkov по расписанию
```

## Модуль и переменные

Окружения вызывают модуль из `Task1Advanced/modules/vm` и передают параметры через объект `vm_profile`. Пример для dev (см. `envs/dev/main.tf`):

```hcl
module "vm_remote" {
  source        = "../../../Task1Advanced/modules/vm"
  environment   = "dev"
  instance_name = var.instance_name != "" ? var.instance_name : "dev-${var.service_name}"
  cpu_cores     = var.vm_profile.cpu_cores
  memory_gb     = var.vm_profile.memory_gb
  data_disk = {
    size_gb = var.vm_profile.data_disk_gb
    type    = var.vm_profile.disk_type
  }
  subnet_id      = var.subnet_id
  ssh_public_key = var.ssh_public_key
  nat            = var.vm_profile.enable_nat
  preemptible    = var.vm_profile.preemptible
  labels         = merge(local.labels_base, var.labels_override)
}
```

`terraform.tfvars` содержит только не чувствительные значения, а секреты прокидываются через GitHub Actions.

## Backend

Каждое окружение объявляет `backend "s3"` с уникальным `key`. Сценарий `scripts/setup-backend.sh`:

1. Проверяет наличие `STATE_BUCKET` и `LOCK_TABLE` (значения по умолчанию заданы в скрипте).
2. Создаёт бакет с включённым версионированием и шифрованием.
3. Создаёт таблицу блокировок.
4. Выполняет `terraform init` для `envs/dev|stage|prod` с общими параметрами backend.

Необходимые переменные окружения для скрипта: `YC_ACCESS_KEY_ID`, `YC_SECRET_ACCESS_KEY`, а также опционально `STATE_BUCKET`, `LOCK_TABLE`, `AWS_REGION`, `S3_ENDPOINT`, `DYNAMODB_ENDPOINT`.

## GitHub Actions

| Workflow | Назначение | Особенности |
| --- | --- | --- |
| `terraform-plan.yml` | init + plan для dev/stage/prod на push/PR | Использует matrix, собирает артефакты планов |
| `terraform-apply.yml` | ручной запуск через `workflow_dispatch` | Выбор окружения, флаг `auto_apply`, использует approval через среды |
| `terraform-security.yml` | tfsec + Checkov | По расписанию и вручную |

Обязательные repository variables:

| Var | Пример |
| --- | --- |
| `STATE_BUCKET` | `future20-terraform-state` |
| `LOCK_TABLE` | `future20-terraform-locks` |
| `S3_ENDPOINT` | `https://storage.yandexcloud.net` |
| `AWS_REGION` | `ru-central1` |

Обязательные secrets (создаются отдельно для окружений dev/stage/prod, чтобы включить approval):

| Secret | Описание |
| --- | --- |
| `YC_ACCESS_KEY_ID` / `YC_SECRET_ACCESS_KEY` | ключи Object Storage |
| `YANDEX_TOKEN` | OAuth токен Terraform-провайдера |
| `YC_CLOUD_ID`, `YC_FOLDER_ID` | контекст YC |
| `YC_SUBNET_ID` | подсеть окружения |
| `SSH_PUBLIC_KEY` | публичный ключ пользователя |

Сценарий `validate-secrets.sh` проверяет присутствие переменных `YC_ACCESS_KEY_ID`, `YC_SECRET_ACCESS_KEY`, `TF_VAR_yandex_token`, `TF_VAR_cloud_id`, `TF_VAR_folder_id`, `TF_VAR_subnet_id`, `TF_VAR_ssh_public_key`. При необходимости список можно переопределить через `REQUIRED_VARS`.

## Локальный запуск

```bash
cd Task2Advanced/envs/dev
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
terraform init \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="endpoint=${S3_ENDPOINT}" \
  -backend-config="region=${AWS_REGION}" \
  -backend-config="dynamodb_table=${LOCK_TABLE}" \
  -backend-config="skip_credentials_validation=true" \
  -backend-config="skip_region_validation=true" \
  -backend-config="skip_metadata_api_check=true" \
  -backend-config="force_path_style=true"
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Безопасность и изоляция

- У каждого окружения собственный state-файл (отличные `key` в backend).
- GitHub environments используются для контроля доступа и approvals (например, для prod требуется ручное подтверждение workflow).
- Хранение состояния включает версионирование и серверное шифрование; блокировки исключают одновременные изменения.
- Плановые security-сканы выполняются tfsec и Checkov.

## Отладка

- `scripts/setup-backend.sh` перезапускает `terraform init` при смене параметров backend.
- `scripts/validate-secrets.sh` помогает быстро найти отсутствующий секрет.
- Все workflow публикуют artefacts с планами, что позволяет просматривать diff до применения.
