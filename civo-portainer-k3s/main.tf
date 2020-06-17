module "cluster" {
  source = "./cluster"

  auth_token = var.auth_token
}

module "ingress" {
  source = "./ingress"

  kubeconf_path = module.cluster.kubeconf_path
  config_user = module.cluster.config_user
  cluster_name = module.cluster.cluster_name
}
