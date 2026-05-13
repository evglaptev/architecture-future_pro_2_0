variable "instance_name" {
  description = "Желаемое имя виртуальной машины (если пусто, формируется автоматически)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Имя окружения, используется в тегах и именах ресурсов"
  type        = string
}

variable "cpu_cores" {
  description = "Количество vCPU"
  type        = number
}

variable "memory_gb" {
  description = "Объём оперативной памяти, ГБ"
  type        = number
}

variable "core_fraction" {
  description = "Доля производительности ядра (ставьте 100 для полноценных ядер)"
  type        = number
  default     = 100
}

variable "data_disk" {
  description = "Конфигурация дополнительного диска"
  type = object({
    size_gb = number
    type    = string
  })
}

variable "boot_disk" {
  description = "Параметры системного диска"
  type = object({
    size_gb = number
    type    = string
  })
  default = {
    size_gb = 20
    type    = "network-ssd"
  }
}

variable "subnet_id" {
  description = "Подсеть для подключения сетевого интерфейса"
  type        = string
}

variable "nat" {
  description = "Нужен ли публичный IP (NAT)"
  type        = bool
  default     = true
}

variable "preemptible" {
  description = "Использовать ли прерываемую ВМ"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "ssh_username" {
  description = "Пользователь в гостевой ОС для доступа по SSH"
  type        = string
  default     = "ubuntu"
}

variable "image_family" {
  description = "Семейство образов ОС в Yandex Cloud"
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

variable "labels" {
  description = "Дополнительные метки ресурсов"
  type        = map(string)
  default     = {}
}

variable "additional_metadata" {
  description = "Произвольные метаданные для гостевой ОС"
  type        = map(string)
  default     = {}
}
