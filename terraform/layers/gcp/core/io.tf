
variable "gcp_org_name" {
  default = ""
}
variable "gcp_project" {}

variable "project" {}
variable "environment" {}
variable "region" {}
variable "layer" {}
variable "state_bucket" {}
variable "ansible_vault_password" {}
variable "ssh_keys" {
  default = []
}

output "core_instance_ipv4_addresses" {
  value = "${module.core_instance.instance_ips}"
}
