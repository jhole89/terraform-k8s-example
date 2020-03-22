provider "kubernetes" {
  config_context_auth_info =  var.okteto_cluser_user
  config_context_cluster = var.okteto_cluster_name
}
