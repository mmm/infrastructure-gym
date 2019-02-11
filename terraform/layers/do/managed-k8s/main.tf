terraform {
  backend "s3" {}
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
  version = "1.1.0"
}

data "terraform_remote_state" "core" {
  backend = "s3"

  config {
    bucket                      = "${var.state_bucket}"
    key                         = "infrastructure/${var.project}/${var.environment}/state/do/core.tfstate"
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

resource "digitalocean_tag" "k8s" {
  name = "${var.project}:${var.environment}:k8s"
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name = "${var.project}-${var.environment}-k8s-cluster"
  region = "${var.region}"
  version = "1.13.2-do.1"
  tags = [
    "${digitalocean_tag.k8s.id}",
  ]

  node_pool {
    name = "${var.project}-${var.environment}-k8s-pool-0"
    node_count = 3
    #size       = "s-4vcpu-8gb"
    size       = "c-8"
    tags = [
      "${digitalocean_tag.k8s.id}",
    ]
  }
}
