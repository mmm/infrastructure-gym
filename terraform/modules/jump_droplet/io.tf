
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

variable "ansible_tarball" {
  default = {}
}

output "ipv4_address_list" {
  value = "${digitalocean_floating_ip.jump.*.ip_address}"
}
