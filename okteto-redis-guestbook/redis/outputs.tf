output "service_endpoint" {
  value = "https://${kubernetes_service.service.metadata[0].name}-${var.namespace}.cloud.okteto.net/"
}
