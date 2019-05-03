
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

