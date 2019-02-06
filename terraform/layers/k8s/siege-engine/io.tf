
variable "kubeconfig" {
  default = ""
}
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

variable "siegeengine_image" {
  default = "markmims/siege-engine:latest"
}
variable "siegeengine_name" {
  default = "simple"
}
variable "siegeengine_target" {
  default = ""
}
variable "siegeengine_replicas" {
  default = 1
}
variable "siegeengine_threads_per_replica" {
  default = 1
}
variable "siegeengine_timeout" {
  default = 30
}
