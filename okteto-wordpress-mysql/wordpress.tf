locals {
  wordpress_labels = {
    app = var.app
    tier = "frontend"
  }
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = local.wordpress_labels.app
    namespace = var.okteto_cluster_namespace
    labels = {
      app = local.wordpress_labels.app
    }
  }
  spec {
    selector {
      match_labels = local.wordpress_labels
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = local.wordpress_labels
      }
      spec {
        container {
          name = local.wordpress_labels.app
          image = "wordpress:4.8-apache"
          env {
            name = "WORDPRESS_DB_HOST"
            value = "wordpress-mysql"
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value = kubernetes_secret.mysql.data.password
          }
          port {
            container_port = 80
            name = local.wordpress_labels.app
          }
          volume_mount {
            name = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }
        }
        volume {
          name = "wordpress-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wordpress.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name = "${var.app}-${local.wordpress_labels.tier}-pv-claim"
    namespace = var.okteto_cluster_namespace
    labels = {
      app = var.app
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = kubernetes_deployment.wordpress.metadata[0].name
    namespace = kubernetes_deployment.wordpress.metadata[0].namespace
    labels = {
      app = kubernetes_deployment.wordpress.metadata[0].labels.app
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      port = 80
    }
    selector = kubernetes_deployment.wordpress.spec[0].template[0].metadata[0].labels
  }
}