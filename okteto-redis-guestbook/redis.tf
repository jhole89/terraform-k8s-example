module "master" {
  source = "./redis"

  namespace = var.okteto_cluster_namespace
  role = "master"
  container_port = 6379
  service_port = 6379
}

module "slave" {
  source = "./redis"

  namespace = var.okteto_cluster_namespace
  role = "slave"
  replicas = 2
  container_port = 6379
  service_port = 6379
  env = [{
    name = "GET_HOSTS_FROM"
    value = "dns"
  }]
}