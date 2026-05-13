terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.116"
    }
  }

  backend "s3" {
    key = "envs/prod/terraform.tfstate"
  }
}

locals {
  environment = "prod"
  labels_base = {
    system      = "future20"
    stage       = local.environment
    criticality = "high"
  }
}

provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "vm_remote" {
  source = "../../../Task1Advanced/modules/vm"

  environment   = local.environment
  instance_name = var.instance_name != "" ? var.instance_name : "${local.environment}-${var.service_name}"
  cpu_cores     = var.vm_profile.cpu_cores
  memory_gb     = var.vm_profile.memory_gb
  core_fraction = var.vm_profile.core_fraction

  data_disk = {
    size_gb = var.vm_profile.data_disk_gb
    type    = var.vm_profile.disk_type
  }

  boot_disk = {
    size_gb = var.boot_disk_size_gb
    type    = var.boot_disk_type
  }

  subnet_id      = var.subnet_id
  nat            = var.vm_profile.enable_nat
  preemptible    = var.vm_profile.preemptible
  ssh_public_key = var.ssh_public_key
  ssh_username   = var.ssh_username
  image_family   = var.image_family
  zone           = var.zone
  platform_id    = var.platform_id
  labels         = merge(local.labels_base, var.labels_override)
}

