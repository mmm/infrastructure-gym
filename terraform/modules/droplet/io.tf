
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

variable "ansible_tarball" {
  default = {}
}

output "ipv4_address_list" {
  value = [ "${digitalocean_droplet.generic_droplet.*.ipv4_address}" ]
}
