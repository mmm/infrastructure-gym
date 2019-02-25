terraform {
  backend "s3" {}
}

provider "helm" {
  "kubernetes" {
    config_path = "${var.kubeconfig}"
  }
  version = "~> 0.8"
}

resource "helm_repository" "confluentinc" {
    name = "confluentinc"
    url  = "https://confluentinc.github.io/cp-helm-charts/"
}

resource "helm_release" "kfk" {
    name      = "kafka"
    namespace = "${var.project}-${var.environment}"
    chart     = "confluentinc/cp-helm-charts"
    version   = "0.1.0"

    values = [
      "${file("kafka-values.yml")}"
    ]
    #set {
        #name = "cp-zookeeper.persistence.enabled"
        #value = "false"
    #}
    #set {
        #name = "cp-zookeeper.enabled"
        #value = "true"
    #}
    #set {
        #name = "cp-kafka.persistence.enabled"
        #value = "false"
    #}
    #set {
        #name = "cp-kafka.enabled"
        #value = "true"
    #}
    #set {
        #name = "cp-ksql-server.enabled"
        #value = "false"
    #}
    #set {
        #name = "cp-schema-registry.enabled"
        #value = "false"
    #}
    #set {
        #name = "cp-kafka-rest.enabled"
        #value = "false"
    #}
    #set {
        #name = "cp-kafka-connect.enabled"
        #value = "false"
    #}
}

