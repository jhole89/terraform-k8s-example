output "node_port" {
  value = kubernetes_service.example_service.spec[0].port[0].node_port
}
