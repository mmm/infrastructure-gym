terraform {
  backend "gcs" {}
}
provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

data "google_organization" "org" {
  domain = "${var.gcp_org_name}"
}

#resource "google_folder" "sales" {
  #display_name = "Sales"
  #parent       = "${data.google_organization.org.name}"
#}

#data "google_billing_account" "acct" {
  #billing_account = "014BD4-ED1E74-45F6D8"
  ##display_name = "markmims"
#}

# can't add a project to the central billing account
#resource "google_project" "gcp_project" {
  #name       = "mmm-ad-88c1"
  #project_id = "mmm-ad-88c1"
  #org_id     = "${data.google_organization.org.id}"
  ##billing_account = "${data.google_billing_account.acct.id}"
#}

#resource "google_compute_network" "vpc_network" {
  #name = "vpc-network"
#}

#resource "digitalocean_tag" "bastion_subnet" {
  #name = "${var.project}:${var.environment}:subnet:bastions"
#}
#resource "digitalocean_tag" "inside_subnet" {
  #name = "${var.project}:${var.environment}:subnet:inside"
#}

module "core_instance" {
  source = "../../../modules/gcp/generic_instance"
  name = "core"
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

