resource "kubernetes_namespace" "example_namespace" {
  metadata {
    name = "${var.label}-namespace"
  }
}

resource "kubernetes_service" "example_service" {
  metadata {
    name = "${var.label}-service"
    namespace = kubernetes_namespace.example_namespace.metadata[0].name
    labels = {
      app = kubernetes_deployment.example_deployment.metadata[0].labels.app
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment.example_deployment.metadata[0].labels.app
    }

    port {
      port        = var.service_internal_port
      target_port = kubernetes_deployment.example_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    type = var.service_exposure
  }
}

resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name = "${var.label}-deployment"
    namespace = kubernetes_namespace.example_namespace.metadata[0].name
    labels = {
      app = var.label
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.label
      }
    }
    template {
      metadata {
        labels = {
          app = var.label
        }
      }
      spec {
        container {
          name = var.label
          image = var.image
          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}
