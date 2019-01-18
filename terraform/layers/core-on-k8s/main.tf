terraform {
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "${var.kubeconfig}"
}

resource "kubernetes_namespace" "project-environment" {
  metadata {
    annotations {
      name = "some-annotation"
    }
    labels {
      mylabel = "label-value"
    }
    name = "${var.project}-${var.environment}"
  }
}
