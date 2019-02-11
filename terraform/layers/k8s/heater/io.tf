
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

variable "heater_image" {
  default = "markmims/heater:latest"
}
variable "heater_name" {
  default = "simple"
}
variable "heater_replicas" {
  default = 4
}
variable "heater_threads_per_replica" {
  default = 1
}
variable "heater_timeout" {
  default = 10
}
variable "heater_port" {
  default = 80
}

#output "lb_ip" {
  #value = "${kubernetes_service.heater.load_balancer_ingress.0.ip}"
#}
