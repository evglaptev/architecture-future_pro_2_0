# Baseline parameters for prod
yandex_token   = "your-oauth-token-here"
cloud_id       = "your-cloud-id-here"
folder_id      = "your-folder-id-here"
subnet_id      = "your-subnet-id-here"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-email@example.com"

service_name = "prod-gateway"

vm_profile = {
  cpu_cores     = 8
  memory_gb     = 16
  core_fraction = 100
  data_disk_gb  = 120
  disk_type     = "network-ssd"
  enable_nat    = false
  preemptible   = false
}

boot_disk_size_gb = 40
boot_disk_type    = "network-ssd"

image_family = "ubuntu-2204-lts"
zone         = "ru-central1-c"
platform_id  = "standard-v3"
