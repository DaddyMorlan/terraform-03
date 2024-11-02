resource "yandex_compute_disk" "count" {
  count = 3
  name  = "disk-${count.index + 1}"
  type  = var.vms_specs_hw["storage"].hdd_type
  size  = var.vms_specs_hw["storage"].hdd_size_secondary
  zone  = var.default_zone
}

resource "yandex_compute_instance" "disk_vm" {
  name = var.vms_specs_hw["storage"].name
  zone = var.default_zone
  resources {
    cores         = var.vms_specs_hw["storage"].cores
    memory        = var.vms_specs_hw["storage"].memory
    core_fraction = var.vms_specs_hw["storage"].core_fraction

  }
  boot_disk {
    initialize_params {
      type     = var.vms_specs_hw["storage"].hdd_type
      size     = var.vms_specs_hw["storage"].hdd_size
      image_id = data.yandex_compute_image.ubuntu.image_id
    }

  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.count
    content {
      disk_id = secondary_disk.value.id
    }
  }
  scheduling_policy {
    preemptible = var.vms_specs_hw["storage"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_specs_hw["storage"].nat
  }
}
