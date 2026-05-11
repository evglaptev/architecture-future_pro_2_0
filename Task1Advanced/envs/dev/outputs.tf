output "instance_id" {
  description = "ID виртуальной машины"
  value       = module.vm_remote.instance_id
}

output "public_ip" {
  description = "Публичный IP"
  value       = module.vm_remote.public_ip
}

output "private_ip" {
  description = "Внутренний IP"
  value       = module.vm_remote.private_ip
}

output "ssh_command" {
  description = "Команда подключения"
  value       = module.vm_remote.ssh_command
}

output "data_disk_id" {
  description = "ID дополнительного диска"
  value       = module.vm_remote.data_disk_id
}
