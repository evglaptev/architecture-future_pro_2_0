# Универсальный модуль Terraform для ВМ

Модуль `modules/vm` разворачивает виртуальную машину Yandex Cloud с отдельным data-диском и единым интерфейсом для разных окружений. В каталоге `envs` лежат три независимых стека с разными профилями ресурсоемкости.

```
Task1Advanced
├── envs/
│   ├── dev/    # экономный профиль, прерываемые ВМ
│   ├── stage/  # средний профиль для регресса
│   └── prod/   # производительный профиль
├── examples.tf # справочные варианты встраивания модуля
└── modules/
    └── vm/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## Интерфейс модуля

| Параметр | Тип | Назначение |
| --- | --- | --- |
| `cpu_cores` | number | Требуемое число vCPU |
| `memory_gb` | number | Объем RAM в ГБ |
| `data_disk` | object({ size_gb, type }) | Конфигурация дополнительного диска |
| `subnet_id` | string | Подсеть для сетевого интерфейса |
| `ssh_public_key` | string | Ключ для доступа |
| `environment` | string | Тег окружения |
| `instance_name` | string (optional) | Явное имя ВМ |
| `boot_disk` | object({ size_gb, type }) | Параметры системного диска, по умолчанию 20 ГБ SSD |
| `nat` | bool | Выдавать ли публичный IP |
| `preemptible` | bool | Включать ли прерываемые ВМ |
| `core_fraction` | number | Доля vCPU (100 по умолчанию) |
| `image_family`, `platform_id`, `zone`, `ssh_username`, `labels`, `additional_metadata` | опциональные настройки |

Выходы:

| Output | Описание |
| --- | --- |
| `instance_id`, `instance_name` | Идентификаторы ресурса |
| `public_ip`, `private_ip` | Сетевые адреса |
| `data_disk_id`, `data_disk_size_gb` | Сведения о подключенном диске |
| `labels`, `environment` | Итоговые теги |
| `ssh_command` | Готовая команда подключения |

## Как запустить окружение

1. Укажите учетные данные и профиль виртуальной машины в `envs/<env>/terraform.tfvars`.
2. Выполните стандартный цикл Terraform:

```bash
cd envs/dev
terraform init
terraform plan  -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

Для Stage и Prod повторите шаги в соответствующих каталогах. Уничтожение ресурсов выполняется командой `terraform destroy -var-file="terraform.tfvars"`.

## Профили окружений

- `dev` — 2 vCPU, 4 ГБ RAM, data-диск 30 ГБ, NAT включен, ВМ прерываемая.
- `stage` — 4 vCPU, 8 ГБ RAM, data-диск 60 ГБ, стабильные ВМ.
- `prod` — 8 vCPU, 16 ГБ RAM, data-диск 120 ГБ, выделенное железо без прерываний.

## Встраивание модуля

```hcl
module "vm" {
  source        = "./modules/vm"
  environment   = "analytics"
  instance_name = "analytics-api"
  cpu_cores     = 4
  memory_gb     = 8
  data_disk = {
    size_gb = 80
    type    = "network-ssd"
  }
  subnet_id       = "e9b1h0icgtq23md5ovl1"
  ssh_public_key  = file("~/.ssh/id_rsa.pub")
  ssh_username    = "ubuntu"
  labels = {
    service = "data-platform"
  }
}
```

Модуль не использует захардкоженные параметры окружений и одинаково применяется в dev/stage/prod через `terraform apply -var-file=...`.
