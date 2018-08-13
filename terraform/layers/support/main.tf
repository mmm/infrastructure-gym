terraform {
  backend "s3" {}
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

data "terraform_remote_state" "core" {
  backend = "s3"

  config {
    bucket   = "${var.state_bucket}"
    key      = "state/${var.environment}/core.tfstate"
    region   = "us-west-2" # not used, but hard-coded to trick the state back-end
    endpoint = "https://${var.region}.digitaloceanspaces.com"
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
  }
}

resource "digitalocean_tag" "role_bastion" {
  name = "role:bastion"
}

module "jump_droplets" {
  source = "../../modules/jump_droplet"
  count = 2 
  region = "${var.region}"
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${data.terraform_remote_state.core.digitalocean_tag_jump_id}",
    "${digitalocean_tag.role_bastion.id}",
  ]
  ansible_tarball = {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "${var.region}"
    bucket = "${var.stack_state_bucket}"
    vault_password = "${var.ansible_vault_password}"
    role = "${digitalocean_tag.role_bastion.name}"
  }
}

resource "digitalocean_tag" "role_consul" {
  name = "role:consul"
}

module "consul_droplets" {
  source = "../../modules/dev_droplet"
  droplet_name = "consul"
  count = 3 
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${data.terraform_remote_state.core.digitalocean_tag_dev_id}",
    "${digitalocean_tag.role_consul.id}",
  ]
  source_tags = [
    "${data.terraform_remote_state.core.digitalocean_tag_jump_id}",
  ]
  ansible_tarball = {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "${var.region}"
    bucket = "${var.stack_state_bucket}"
    vault_password = "${var.ansible_vault_password}"
    role = "${digitalocean_tag.role_consul.name}"
  }
}
