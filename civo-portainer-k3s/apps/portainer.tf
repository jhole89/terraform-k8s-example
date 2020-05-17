locals {
  name = "portainer"
}

resource "kubernetes_namespace" "portainer" {
  metadata {
    name = local.name
  }
}

resource "kubernetes_service_account" "portainer" {
  metadata {
    name = "${local.name}-sa-clusteradmin"
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "portainer" {
  metadata {
    name = "${local.name}-crb-clusteradmin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.portainer.metadata[0].name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
}

resource "kubernetes_service" "portainer" {
  metadata {
    name = local.name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "app-${local.name}"
    }
    port {
      name = "http"
      protocol = "TCP"
      port = 9000
      target_port = 9000
    }
    port {
      name = "edge"
      protocol = "TCP"
      port = 8000
      target_port = 8000
    }
  }
}

resource "kubernetes_deployment" "portainer" {
  metadata {
    name = local.name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
  spec {
    selector {
      match_labels = kubernetes_service.portainer.spec[0].selector
    }
    template {
      metadata {
        labels = kubernetes_service.portainer.spec[0].selector
      }
      spec {
        service_account_name = kubernetes_service_account.portainer.metadata[0].name
        container {
          name = local.name
          image = "portainer/portainer-k8s-beta:linux-amd64"
          image_pull_policy = "Always"
          port {
            protocol = "TCP"
            container_port = "8000"
          }
          port {
            protocol = "TCP"
            container_port = "9000"
          }
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.portainer.default_secret_name
            read_only  = true
          }
        }
        volume {
          name = kubernetes_service_account.portainer.default_secret_name

          secret {
            secret_name = kubernetes_service_account.portainer.default_secret_name
          }
        }
      }
    }
  }
}
