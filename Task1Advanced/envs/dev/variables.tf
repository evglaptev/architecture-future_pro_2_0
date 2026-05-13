variable "service_name" {
  description = "Логическое имя сервиса для формирования названия ВМ"
  type        = string
  default     = "vm"
}

variable "instance_name" {
  description = "Принудительное имя ресурса (опционально)"
  type        = string
  default     = ""
}

variable "yandex_token" {
  description = "OAuth токен Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID папки"
  type        = string
}

variable "subnet_id" {
  description = "Подсеть, в которой размещаем ВМ"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный ключ доступа"
  type        = string
}

variable "ssh_username" {
  description = "Пользователь в гостевой ОС"
  type        = string
  default     = "ubuntu"
}

variable "image_family" {
  description = "Семейство образов ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  description = "Аппаратная платформа"
  type        = string
  default     = "standard-v2"
}

variable "boot_disk_size_gb" {
  description = "Размер системного диска"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Тип системного диска"
  type        = string
  default     = "network-ssd"
}

variable "vm_profile" {
  description = "Параметры ВМ для данного окружения"
  type = object({
    cpu_cores     = number
    memory_gb     = number
    core_fraction = number
    data_disk_gb  = number
    disk_type     = string
    enable_nat    = bool
    preemptible   = bool
  })
}

variable "labels_override" {
  description = "Дополнительные метки"
  type        = map(string)
  default     = {}
}
