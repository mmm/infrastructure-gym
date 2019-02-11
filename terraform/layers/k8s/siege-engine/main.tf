terraform {
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "${var.kubeconfig}"
  version = "~> 1.5"
}

resource "kubernetes_deployment" "siegeengine" {
  metadata {
    name = "siegeengine-${var.siegeengine_name}"
    namespace = "${var.project}-${var.environment}"
    labels {
      App = "siegeengine-${var.siegeengine_name}"
    }
  }

  spec {
    replicas = "${var.siegeengine_replicas}"
    selector {
      match_labels {
        App = "siegeengine-${var.siegeengine_name}"
      }
    }
    template {
      metadata {
        name = "siegeengine-${var.siegeengine_name}"
        namespace = "${var.project}-${var.environment}"
        labels {
          App = "siegeengine-${var.siegeengine_name}"
        }
      }

      spec {
        container {
          image = "${var.siegeengine_image}"
          name  = "siegeengine-${var.siegeengine_name}"
          env = [
            {
              name = "SIEGE_TARGET"
              value = "${var.siegeengine_target}"
            },
            {
              name = "SIEGE_THREADS"
              value = "${var.siegeengine_threads_per_replica}"
            },
            {
              name = "SIEGE_TIMEOUT"
              value = "${var.siegeengine_timeout}"
            },
          ]
        }
      }
    }
  }
}
