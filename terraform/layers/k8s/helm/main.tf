terraform {
  backend "s3" {}
}

provider "null" {
  version = "~> 2.0"
}

provider "kubernetes" {
  config_path = "${var.kubeconfig}"
  version = "~> 1.5"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}


resource "kubernetes_cluster_role_binding" "tiller-cluster-rule" {
  metadata {
    name = "tiller-cluster-rule"
  }
  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "null_resource" "tiller_install" {
  provisioner "local-exec" {
    command = "helm --kubeconfig ${var.kubeconfig} init --service-account tiller --upgrade"
  }
}
