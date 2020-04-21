locals {
  labels = {
    app = "redis"
    tier = "backend"
    role = var.role
  }
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "${local.labels.app}-${local.labels.role}"
    namespace = var.namespace
    labels = {
      app = local.labels.app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.labels
    }
    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          name = local.labels.role
          image = var.role == "master" ? "k8s.gcr.io/redis:e2e" : "gcr.io/google_samples/gb-redisslave:v3"
          resources {
            requests {
              cpu = "100m"
              memory = "100Mi"
            }
          }
          port {
            container_port = var.container_port
          }
          dynamic env {
            for_each = var.env
            content {
              name = env.value["name"]
              value = env.value["value"]
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = kubernetes_deployment.deployment.metadata[0].name
    namespace = var.namespace
    labels = kubernetes_deployment.deployment.spec[0].template[0].metadata[0].labels
  }

  spec {
    selector = kubernetes_deployment.deployment.metadata[0].labels

    port {
      port = var.service_port
      target_port = kubernetes_deployment.deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}
