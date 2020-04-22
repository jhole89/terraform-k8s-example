locals {
  mysql_labels = {
    app = var.app
    tier = "mysql"
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "${local.mysql_labels.app}-mysql"
    namespace = var.okteto_cluster_namespace
    labels = {
      app = local.mysql_labels.app
    }
  }
  spec {
    selector {
      match_labels = local.mysql_labels
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = local.mysql_labels
      }
      spec {
        container {
          name = local.mysql_labels.tier
          image = "${local.mysql_labels.tier}:5.6"
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = kubernetes_secret.mysql.data.password
          }
          port {
            container_port = 3306
            name = local.mysql_labels.tier
          }
          volume_mount {
            mount_path = "/var/lib/mysql"
            name = "mysql-persistent-storage"
          }
        }
        volume {
          name = "mysql-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name = "${var.app}-${local.mysql_labels.tier}-pv-claim"
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

resource "kubernetes_service" "mysql" {
  metadata {
    name = kubernetes_deployment.mysql.metadata[0].name
    namespace = kubernetes_deployment.mysql.metadata[0].namespace
    labels = {
      app = kubernetes_deployment.mysql.metadata[0].labels.app
    }
  }
  spec {
    port {
      port = 3306
    }
    selector = kubernetes_deployment.mysql.spec[0].template[0].metadata[0].labels
    cluster_ip = "None"
  }
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name = "${local.mysql_labels.tier}-pass"
    namespace = var.okteto_cluster_namespace
  }
  data = {
    password = var.mysql_password
  }
}
