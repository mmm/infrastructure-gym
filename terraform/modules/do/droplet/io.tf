
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
  default = "droplet"
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

variable "droplet_subnet" {
  default = "subnet:droplet"
}

variable "ansible_tarball" {
  default = {}
}

output "droplet_ids" {
  value = [ "${digitalocean_droplet.generic.*.id}" ]
}

output "ipv4_address_list" {
  value = [ "${digitalocean_droplet.generic.*.ipv4_address}" ]
}

