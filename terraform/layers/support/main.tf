terraform {
  backend "s3" {}
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

data "terraform_remote_state" "core" {
  backend = "s3"

  config {
    bucket                      = "${var.state_bucket}"
    key                         = "infrastructure/${var.project}/${var.environment}/state/core.tfstate"
    region                      = "us-west-2" # not used, but hard-coded to trick the state back-end
    endpoint                    = "https://${var.region}.digitaloceanspaces.com"
    access_key                  = "${var.aws_access_key_id}"
    secret_key                  = "${var.aws_secret_access_key}"
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}

resource "digitalocean_tag" "role_bastion" {
  name = "${var.project}:${var.environment}:ansible_role:bastion"
}

module "bastions" {
  source = "../../modules/bastion_droplet"
  droplet_name = "${var.project}-${var.environment}-bastion"
  count = 1 
  project = "${var.project}"
  environment = "${var.environment}"
  region = "${var.region}"
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${digitalocean_tag.role_bastion.id}",
  ]
  bastion_subnet = "${data.terraform_remote_state.core.digitalocean_tag_bastion_subnet}"
  ansible_tarball = {
    project            = "${var.project}"
    environment        = "${var.environment}"
    region             = "${var.region}"
    bucket             = "${var.state_bucket}"
    access_key         = "${var.aws_access_key_id}"
    secret_key         = "${var.aws_secret_access_key}"
    digitalocean_token = "${var.digitalocean_token}"
    vault_password     = "${var.ansible_vault_password}"
    role               = "${digitalocean_tag.role_bastion.name}"
  }
}

resource "digitalocean_tag" "role_consul" {
  name = "${var.project}:${var.environment}:ansible_role:consul_server"
}

module "consul_servers" {
  source = "../../modules/droplet"
  droplet_name = "${var.project}-${var.environment}-consul"
  count = 1
  project = "${var.project}"
  environment = "${var.environment}"
  region = "${var.region}"
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${digitalocean_tag.role_consul.id}",
  ]
  droplet_subnet = "${data.terraform_remote_state.core.digitalocean_tag_inside_subnet}"
  ansible_tarball = {
    project = "${var.project}"
    environment = "${var.environment}"
    region = "${var.region}"
    bucket = "${var.state_bucket}"
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    digitalocean_token = "${var.digitalocean_token}"
    vault_password = "${var.ansible_vault_password}"
    role = "${digitalocean_tag.role_consul.name}"
  }
}

resource "digitalocean_firewall" "firewall_bastion_to_inside" {
  name = "${var.project}-${var.environment}-bastion-to-inside"

  tags        = ["${data.terraform_remote_state.core.digitalocean_tag_inside_subnet}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_tags        = ["${data.terraform_remote_state.core.digitalocean_tag_bastion_subnet}"]
    },
    {
      protocol           = "tcp"
      port_range         = "8300-8301"
      source_tags        = ["${data.terraform_remote_state.core.digitalocean_tag_bastion_subnet}"]
    },
  ]

  outbound_rule = []
}

