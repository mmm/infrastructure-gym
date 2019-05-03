terraform {
  backend "gcs" {}
}
provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

module "core_instance" {
  source = "../../../modules/gcp/generic_instance"
  name = "core"
  #machine_type = "n1-standard-1"

  ssh_keys = ["${var.ssh_keys}"]
}

