output "frontend_url" {
  value = "https://${kubernetes_service.frontend.metadata[0].name}-${var.okteto_cluster_namespace}.cloud.okteto.net/"
}
