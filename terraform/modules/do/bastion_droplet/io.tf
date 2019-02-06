
variable "project" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "layer" {
  default = ""
}

variable "region" {
  default = "ams3"
}

variable "droplet_name" {
  default = "jump"
}

variable "count" {
  default = 1
}

variable "ssh_keys" {
  default = []
}

variable "tags" {
  default = []
}

variable "bastion_subnet" {
  default = "subnet:bastions"
}

variable "ansible_tarball" {
  default = {}
}

output "ipv4_address_list" {
  value = "${digitalocean_floating_ip.bastion.*.ip_address}"
}
