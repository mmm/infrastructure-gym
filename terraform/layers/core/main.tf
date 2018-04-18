terraform {
  backend "s3" {}
}
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_tag" "tfmanaged" {
  name = "tfmanaged"
}
resource "digitalocean_tag" "dev" {
  name = "dev"
}
resource "digitalocean_tag" "jump" {
  name = "jump"
}
