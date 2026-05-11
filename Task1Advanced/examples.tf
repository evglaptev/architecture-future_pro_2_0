module "batch_vm" {
  source      = "./modules/vm"
  environment = "etl"

  instance_name = "etl-runner-1"
  cpu_cores     = 2
  memory_gb     = 6
  core_fraction = 50

  data_disk = {
    size_gb = 40
    type    = "network-hdd"
  }

  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"

  boot_disk = {
    size_gb = 20
    type    = "network-ssd"
  }

  labels = {
    component = "batch"
  }
}

module "api_vm" {
  source      = "./modules/vm"
  environment = "customer-facing"

  instance_name = "api-core-1"
  cpu_cores     = 6
  memory_gb     = 16

  data_disk = {
    size_gb = 120
    type    = "network-ssd"
  }

  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"
  nat            = false
  preemptible    = false
  platform_id    = "standard-v3"
  zone           = "ru-central1-b"

  boot_disk = {
    size_gb = 40
    type    = "network-ssd"
  }

  labels = {
    component = "public-api"
    owner     = "platform"
  }
}
