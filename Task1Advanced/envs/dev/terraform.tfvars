# Baseline parameters for dev
yandex_token   = "your-oauth-token-here"
cloud_id       = "your-cloud-id-here"
folder_id      = "your-folder-id-here"
subnet_id      = "your-subnet-id-here"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-email@example.com"

service_name = "dev-edge"

vm_profile = {
  cpu_cores     = 2
  memory_gb     = 4
  core_fraction = 20
  data_disk_gb  = 30
  disk_type     = "network-hdd"
  enable_nat    = true
  preemptible   = true
}

boot_disk_size_gb = 20
boot_disk_type    = "network-ssd"

image_family = "ubuntu-2204-lts"
zone         = "ru-central1-a"
platform_id  = "standard-v2"
