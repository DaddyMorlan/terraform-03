resource "yandex_compute_instance" "web" {
    count = 2
    name = "web-${count.index + 1}"
    platform_id = var.vms_specs_hw["web"].platform
    zone = var.default_zone
  resources {
    cores = var.vms_specs_hw["web"].cores
    memory = var.vms_specs_hw["web"].memory
    core_fraction = var.vms_specs_hw["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_specs_hw["web"].hdd_size
      type = var.vms_specs_hw["web"].hdd_type
    }
    
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = toset([yandex_vpc_security_group.example.id])
    nat = var.vms_specs_hw["web"].nat
  }
  scheduling_policy {
    preemptible = var.vms_specs_hw["web"].preemptible
  }
  metadata = {
    serial-port-enable = var.vm_metadata["common"].serial-port-enable
    ssh-keys = local.ssh-keys
  }
}