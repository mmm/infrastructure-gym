
variable "digitalocean_token" {}
variable "project" {}
variable "environment" {}

output "digitalocean_tag_bastion_subnet" {
  value = "${digitalocean_tag.bastion_subnet.name}"
}
output "digitalocean_tag_inside_subnet" {
  value = "${digitalocean_tag.inside_subnet.name}"
}
