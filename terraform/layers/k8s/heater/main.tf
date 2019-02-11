terraform {
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "${var.kubeconfig}"
  version = "~> 1.5"
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
    replicas = "${var.heater_replicas}"
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
          env = [
            {
              name = "HEATER_THREADS"
              value = "${var.heater_threads_per_replica}"
            },
            {
              name = "HEATER_TIMEOUT"
              value = "${var.heater_timeout}"
            },
            {
              name = "HEATER_PORT"
              value = "${var.heater_port}"
            },
          ]
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
      App = "heater-${var.heater_name}"
    }
    port {
      port = "${var.heater_port}"
      target_port = "${var.heater_port}"
    }

    type = "ClusterIP"
    session_affinity = "ClientIP"
    #externalTrafficPolicy = "Local"
  }
}
