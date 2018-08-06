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

module "jump_droplets" {
  source = "../../modules/jump_droplet"
  count = 2 
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${data.terraform_remote_state.core.digitalocean_tag_jump_id}",
  ]
  ansible_tarball = {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "${var.stack_region}"
    bucket = "${var.stack_state_bucket}"
    vault_password = "${var.ansible_vault_password}"
  }
}

