terraform {
  backend "s3" {}
}
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_tag" "bastion_subnet" {
  name = "${var.project}:${var.environment}:subnet:bastions"
}
resource "digitalocean_tag" "inside_subnet" {
  name = "${var.project}:${var.environment}:subnet:inside"
}
