module "cluster" {
  source = "./cluster"

  auth_token = var.auth_token
}

module "apps" {
  source = "./apps"

  kubeconf_path = module.cluster.kubeconf_path
  config_user = module.cluster.config_user
  cluster_dns = module.cluster.cluster_dns
  cluster_name = module.cluster.cluster_name
}
