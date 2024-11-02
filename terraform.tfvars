vm_metadata = {
  common = {
    serial-port-enable = 1
  }
}

vms_specs_hw = {
  "web" = {
    platform      = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    preemptible   = true
    nat = false
  }
  "storage" = {
    platform      = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_size_secondary = 1
    hdd_type      = "network-hdd"
    preemptible   = true
    nat = false
    name = "storage"
  }
  "bastion" = {
    platform      = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    preemptible   = true
    nat = true
    name = "bastion"
  }
}

image_name = "ubuntu-2204-lts"

each_vm = [
  {
    vm_name       = "main"
    cpu           = 4
    ram           = 4
    disk_volume   = 10
    platform      = "standard-v1"
    core_fraction = 5
    hdd_type      = "network-hdd"
    preemptible   = true
    nat = false
  },
  {
    vm_name       = "replica"
    cpu           = 2
    ram           = 2
    disk_volume   = 11
    platform      = "standard-v1"
    core_fraction = 5
    hdd_type      = "network-hdd"
    preemptible   = true
    nat = false
  }
]
