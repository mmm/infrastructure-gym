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
    bucket                      = "${var.state_bucket}"
    key                         = "infrastructure/${var.project}/${var.environment}/state/gcp/core.tfstate"
  }
}

resource "google_container_cluster" "primary" {
  name = "${var.project}-${var.environment}-k8s-cluster"
  location           = "us-central1-c"
  initial_node_count = 3

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata {
      disable-legacy-endpoints = "true"
    }

    labels = {
      foo = "bar"
    }

    tags = ["foo", "bar"]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
