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

resource "digitalocean_tag" "role_kubernetes_minion" {
  name = "${var.project}:${var.environment}:ansible_role:kubernetes_minion"
}

module "kubernetes_minions" {
  source = "../../modules/worker_droplet"
  droplet_name = "${var.project}-${var.environment}-kubernetes-minion"
  count = 3 
  project = "${var.project}"
  environment = "${var.environment}"
  region = "${var.region}"
  ssh_keys = ["${var.ssh_keys}"]
  tags = [
    "${digitalocean_tag.role_kubernetes_minion.id}",
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
    role = "${digitalocean_tag.role_kubernetes_minion.name}"
  }
}
