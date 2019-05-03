terraform {
  backend "gcs" {}
}
provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

data "terraform_remote_state" "core" {
  backend = "gcs"
  config {
    bucket = "${var.state_bucket}"
    key    = "infrastructure/${var.project}/${var.environment}/state/gcp/core.tfstate"
  }
}

module "bastion" {
  source = "../../../modules/gcp/generic_instance"
  name = "${var.project}-${var.environment}-bastion"
  #machine_type = "n1-standard-1"

  ssh_keys = ["${var.ssh_keys}"]
  ansible_tarball = {
    project            = "${var.project}"
    environment        = "${var.environment}"
    region             = "${var.region}"
    bucket             = "${var.state_bucket}"
    vault_password     = "${var.ansible_vault_password}"
    role               = "ugh"
  }
}
