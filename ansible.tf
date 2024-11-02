variable "web_provision" {
  type    = bool
  default = true
  description="ansible provision switch variable"
}


resource "null_resource" "web_hosts_provision" {
  count = var.web_provision == true ? 1 : 0 
  depends_on = [yandex_compute_instance.web,yandex_compute_instance.db,yandex_compute_instance.disk_vm]

  provisioner "local-exec" {
    command = "eval $(ssh-agent) && cat /home/user/.ssh/id_ed25519 | ssh-add -"
    on_failure  = continue

  }
/*
   provisioner "local-exec" {
     command = "sleep 10"
   }
*/
  provisioner "local-exec" {
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/for.ini ${abspath(path.module)}/test.yml"

    on_failure  = continue 
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
   
  }
  triggers = {
    always_run        = "${timestamp()}"                         #всегда т.к. дата и время постоянно изменяются
    always_run_uuid = "${uuid()}" 
    # playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    # ssh_public_key    = var.public_key                           # при изменении переменной with ssh
    # template_rendered = "${local_file.hosts_templatefile.content}" #при изменении inventory-template
    # password_change = jsonencode( {for k,v in random_password.each: k=>v.result})

  }

}