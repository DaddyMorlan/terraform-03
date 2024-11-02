resource "yandex_compute_instance" "db" {
  for_each    = { for db in var.each_vm : db.vm_name => db }
  name        = each.value.vm_name
  platform_id = each.value.platform
  zone        = var.default_zone
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
      type     = each.value.hdd_type
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat
  }
  scheduling_policy {
    preemptible = each.value.preemptible
  }
  depends_on = [yandex_compute_instance.web]
  metadata = {
    serial-port-enable  = var.vm_metadata["common"].serial-port-enable
    ssh-keys = local.ssh-keys
  }
}
