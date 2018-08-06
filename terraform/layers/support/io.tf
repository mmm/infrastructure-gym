
variable "digitalocean_token" {}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "stack_region" {}
variable "stack_state_bucket" {}
variable "ansible_vault_password" {}
variable "state_bucket" {}
variable "environment" {}
variable "region" {}
variable "layer" {}

variable "ssh_keys" {
  default = []
}

output "jump_ipv4_address_list" {
  value = "${module.jump_droplets.ipv4_address_list}"
}

