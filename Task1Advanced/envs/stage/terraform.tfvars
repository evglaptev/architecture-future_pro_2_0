# Baseline parameters for stage
yandex_token   = "your-oauth-token-here"
cloud_id       = "your-cloud-id-here"
folder_id      = "your-folder-id-here"
subnet_id      = "your-subnet-id-here"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-email@example.com"

service_name = "stage-api"

vm_profile = {
  cpu_cores     = 4
  memory_gb     = 8
  core_fraction = 100
  data_disk_gb  = 60
  disk_type     = "network-ssd"
  enable_nat    = true
  preemptible   = false
}

boot_disk_size_gb = 30
boot_disk_type    = "network-ssd"

image_family = "ubuntu-2204-lts"
zone         = "ru-central1-b"
platform_id  = "standard-v2"
