
variable "region" {
  default = "ams3"
}

variable "droplet_name" {
  default = "dev"
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

variable "source_tags" {
  default = []
}

variable "ansible_tarball" {
  default = {}
}

output "ipv4_address_list" {
  value = [ "${digitalocean_droplet.dev.*.ipv4_address}" ]
}

