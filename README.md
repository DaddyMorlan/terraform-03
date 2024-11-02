# Ссылка на репо: https://github.com/DaddyMorlan/terraform-03
# Задание 1

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/1.png)


# Задание 2

2.1

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.1%20count-vm.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.1%20main.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.1%20terraform%20tfvars.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.1%20variables.png)

2.2

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.2%20foreach.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.2%20local%20ssh.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/2.2%20new%20vars.png)

# Задание 3

3.1

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/3.1%20disk%20vm.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/3.1%20tfvars.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/3.1%20vars.png)

3.2

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/3.2%20vm%20create.png)

# Задание 4

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/4%20code.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/4%20inventory.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/4%20tf.png)

# Задание 5

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/5%20code.png)
![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/4%20tf.png)

# Задание 6

6.1

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/6.1%20apply.jpg)

6.2 ОНО РАБОТАЕТ!!! БАСТИОН ПОДНЯЛСЯ НА ЗАЩИТУ!

![](https://github.com/DaddyMorlan/terraform-03/blob/main/terraform-3/6.2.jpg)

# Задание 7

{
  "network_id"   = local.vpc.network_id
  "subnet_ids"   = concat(slice(local.vpc.subnet_ids, 0, 2), slice(local.vpc.subnet_ids, 3, length(local.vpc.subnet_ids)))
  "subnet_zones" = concat(slice(local.vpc.subnet_zones, 0, 2), slice(local.vpc.subnet_zones, 3, length(local.vpc.subnet_zones)))
}

# Задание 8

скобка должна закрыться после описания ansible_host

[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} platform_id=${i["platform_id"]}
%{~ endfor ~}
