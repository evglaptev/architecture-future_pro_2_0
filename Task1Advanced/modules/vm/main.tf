terraform {
  required_version = ">= 1.4.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.116"
    }
  }
}

data "yandex_compute_image" "selected" {
  family      = var.image_family
  most_recent = true
}

locals {
  instance_name = var.instance_name != "" ? var.instance_name : "vm-${var.environment}"

  base_labels = {
    environment = var.environment
    managed_by  = "terraform"
    component   = "compute"
  }

  labels = merge(local.base_labels, var.labels)
}

resource "yandex_compute_disk" "data" {
  name = "${local.instance_name}-data"
  type = var.data_disk.type
  zone = var.zone
  size = var.data_disk.size_gb

  labels = local.labels
}

resource "yandex_compute_instance" "this" {
  name                      = local.instance_name
  allow_stopping_for_update = true
  platform_id               = var.platform_id
  zone                      = var.zone

  resources {
    cores         = var.cpu_cores
    memory        = var.memory_gb
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.selected.image_id
      size     = var.boot_disk.size_gb
      type     = var.boot_disk.type
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.data.id
    mode    = "READ_WRITE"
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = merge(var.additional_metadata, {
    "ssh-keys"           = "${var.ssh_username}:${var.ssh_public_key}"
    "serial-port-enable" = "1"
  })

  scheduling_policy {
    preemptible = var.preemptible
  }

  labels = local.labels

  lifecycle {
    create_before_destroy = true
  }
}
