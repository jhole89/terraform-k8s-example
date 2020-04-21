locals {
  labels = {
    app = "guestbook"
    tier = "frontend"
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = local.labels.tier
    namespace = var.okteto_cluster_namespace
    labels = {
      app = local.labels.app
    }
  }
  spec {
    selector {
      match_labels = local.labels
    }
    replicas = 3
    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          name = "php-redis"
          image = "gcr.io/google-samples/gb-frontend:v4"
          resources {
            requests {
              cpu = "100m"
              memory = "100Mi"
            }
          }
          env {
            name = "GET_HOSTS_FROM"
            value = "dns"
          }
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = kubernetes_deployment.frontend.metadata[0].name
    namespace = var.okteto_cluster_namespace
    labels = kubernetes_deployment.frontend.spec[0].template[0].metadata[0].labels
  }
  spec {
    type = "NodePort"
    port {
      port = 80
    }
    selector = kubernetes_deployment.frontend.spec[0].template[0].metadata[0].labels
  }
}