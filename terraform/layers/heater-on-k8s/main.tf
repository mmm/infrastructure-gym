terraform {
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "${var.kubeconfig}"
}

resource "kubernetes_deployment" "heater" {
  metadata {
    name = "heater-${var.heater_name}"
    namespace = "${var.project}-${var.environment}"
    labels {
      App = "heater-${var.heater_name}"
    }
  }

  spec {
    replicas = 10
    selector {
      match_labels {
        App = "heater-${var.heater_name}"
      }
    }
    template {
      metadata {
        name = "heater-${var.heater_name}"
        namespace = "${var.project}-${var.environment}"
        labels {
          App = "heater-${var.heater_name}"
        }
      }

      spec {
        container {
          image = "${var.heater_image}"
          name  = "heater-${var.heater_name}"
          port {
            container_port = "${var.heater_port}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "heater" {
  metadata {
    name = "heater-${var.heater_name}"
    namespace = "${var.project}-${var.environment}"
  }
  spec {
    selector {
      App = "${kubernetes_deployment.heater.metadata.0.labels.App}"
    }
    port {
      port = "${var.heater_port}"
      target_port = "${var.heater_port}"
    }

    type = "LoadBalancer"
    session_affinity = "ClientIP"
    #externalTrafficPolicy = "Local"
  }
}
