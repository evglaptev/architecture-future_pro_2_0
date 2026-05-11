# Выходы модуля виртуальной машины

output "instance_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.this.id
}

output "instance_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.this.name
}

output "public_ip" {
  description = "Публичный IP (если NAT включен)"
  value       = yandex_compute_instance.this.network_interface[0].nat_ip_address
}

output "private_ip" {
  description = "Внутренний IP"
  value       = yandex_compute_instance.this.network_interface[0].ip_address
}

output "data_disk_id" {
  description = "ID подключаемого (secondary) диска"
  value       = yandex_compute_disk.data.id
}

output "data_disk_size_gb" {
  description = "Размер дополнительного диска"
  value       = yandex_compute_disk.data.size
}

output "labels" {
  description = "Итоговые метки ресурса"
  value       = yandex_compute_instance.this.labels
}

output "ssh_command" {
  description = "Готовая команда подключения"
  value = var.nat ?
  "ssh ${var.ssh_username}@${yandex_compute_instance.this.network_interface[0].nat_ip_address}" :
  "ssh ${var.ssh_username}@${yandex_compute_instance.this.network_interface[0].ip_address}"
}

output "environment" {
  description = "Окружение"
  value       = var.environment
}
