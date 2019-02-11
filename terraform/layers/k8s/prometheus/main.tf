terraform {
  backend "s3" {}
}

provider "helm" {
  "kubernetes" {
    config_path = "${var.kubeconfig}"
  }
  version = "~> 0.8"
}

resource "helm_release" "prom" {
    name      = "${var.project}-${var.environment}-monitoring"
    namespace = "${var.project}-${var.environment}"
    chart     = "stable/prometheus"
    #version   = "2.2.0"
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

#resource "helm_release" "grafana" {
    #name      = "grafana"
    #namespace = "${var.project}-${var.environment}"
    #chart     = "stable/grafana"

    ##set {
        ##name  = "adminPassword"
        ##value = "foomatic"
    ##}

    ##set {
        ##name = "mariadbPassword"
        ##value = "qux"
    ##}
#}
