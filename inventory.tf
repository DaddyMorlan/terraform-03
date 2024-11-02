resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

    { webservers = yandex_compute_instance.web
      databases  = yandex_compute_instance.db
      storage    = [yandex_compute_instance.disk_vm]
    }

  )

  filename = "${abspath(path.module)}/hosts.ini"
}
/*
output "vms" {
  value = flatten([

    [for vm1 in yandex_compute_instance.web : {
      name = vm1.name
      id   = vm1.id
      fqdn = vm1.fqdn
    }],
    [for vm2 in yandex_compute_instance.db : {
      name = vm2.name
      id   = vm2.id
      fqdn = vm2.fqdn
    }],

    [for vm3 in [yandex_compute_instance.disk_vm] : {
      name = vm3.name
      id   = vm3.id
      fqdn = vm3.fqdn
    }]
  ])
}*/

resource "local_file" "hosts_for" {
  content  = <<-EOT
  %{if length(yandex_compute_instance.web) > 0}
  [webservers]
  %{for i in yandex_compute_instance.web}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != "" ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]} ansible_user=ubuntu
  %{endfor}
  %{endif}
  
  %{if length(yandex_compute_instance.db) > 0}
  [dbservers]
  %{for i in yandex_compute_instance.db}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != "" ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]} ansible_user=ubuntu
  %{endfor}
  %{endif}
  
  %{if length(yandex_compute_instance.disk_vm) > 0}
  [storageservers]
  %{for i in [yandex_compute_instance.disk_vm]}
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != "" ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]} ansible_user=ubuntu
  %{endfor}
  %{endif}

  %{if length(yandex_compute_instance.bastion) > 0}
  [bastion]
  %{for i in [yandex_compute_instance.bastion] }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != null ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]} ansible_user=ubuntu
  [all:vars]
  ansible_ssh_common_args='-o ForwardAgent=yes -o StrictHostKeyChecking=no -o ProxyCommand="ssh -p 22 -W %h:%p -q ubuntu@${i["network_interface"][0]["nat_ip_address"]}"'
  %{endfor}
  %{endif}


  EOT
  filename = "${abspath(path.module)}/for.ini"


}


locals {

  instances_yaml = flatten([
    yandex_compute_instance.web,    
    [for i in yandex_compute_instance.db : yandex_compute_instance.db[i.name]],
    [yandex_compute_instance.disk_vm],
    [yandex_compute_instance.bastion]
    ])

}

resource "local_file" "hosts_yaml" {
  content  = <<-EOT
  all:
    hosts:
    %{for i in local.instances_yaml~}
  ${i["name"]}:
          ansible_host: ${i["network_interface"][0]["nat_ip_address"] != null ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]}
          ansible_user: ubuntu
    %{endfor~}
  EOT
  filename = "${abspath(path.module)}/hosts.yaml"
}

