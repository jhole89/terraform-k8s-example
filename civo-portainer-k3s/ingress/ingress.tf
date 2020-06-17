resource "kubernetes_ingress" "portainer" {
  metadata {
    name = "portainer"
    namespace = "portainer"
    annotations = {
      "ingress.class" = "traefik"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "portainer"
            service_port = "http"
          }
        }
      }
    }
  }
}
