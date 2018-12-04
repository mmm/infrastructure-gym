
variable "project" {}
variable "environment" {}
variable "layer" {}

variable "region" {}
variable "state_bucket" {}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "ansible_vault_password" {}
variable "digitalocean_token" {}

variable "ssh_keys" {
  default = []
}

output "dbpw" {
  value = "${data.null_data_source.dbpw.outputs.value}"
}

