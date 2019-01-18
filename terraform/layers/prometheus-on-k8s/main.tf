terraform {
  backend "s3" {}
}

provider "helm" {
  "kubernetes" {
    config_path = "${var.kubeconfig}"
  }
}

resource "helm_release" "prom" {
    name      = "monitoring"
    namespace = "${var.project}-${var.environment}"
    chart     = "stable/prometheus-operator"
    #version   = "1.6.0"

    #set {
        #name  = "adminPassword"
        #value = "foomatic"
    #}

    #set {
        #name = "mariadbPassword"
        #value = "qux"
    #}
}
