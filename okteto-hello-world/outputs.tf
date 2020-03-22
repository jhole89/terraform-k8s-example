output "url" {
  value = "https://${kubernetes_service.example_service.metadata[0].name}-${var.okteto_cluster_namespace}.cloud.okteto.net/"
}
