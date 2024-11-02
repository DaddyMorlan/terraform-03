resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_name
}

resource "yandex_compute_instance" "bastion" {
  name = var.vms_specs_hw["bastion"].name
  zone = var.default_zone
  platform_id = var.vms_specs_hw["bastion"].platform
  resources {
    cores = var.vms_specs_hw["bastion"].cores
    memory = var.vms_specs_hw["bastion"].memory
    core_fraction = var.vms_specs_hw["bastion"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_specs_hw["bastion"].hdd_size
      type = var.vms_specs_hw["bastion"].hdd_type
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vms_specs_hw["bastion"].nat
  }
  scheduling_policy {
    preemptible = var.vms_specs_hw["bastion"].preemptible
  }
  metadata = {
    serial-port-enable = var.vm_metadata["common"].serial-port-enable
    ssh-keys = local.ssh-keys 
  }
}