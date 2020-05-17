output "cluster_name" {
  value = civo_kubernetes_cluster.k3s.name
}

output "config_user" {
  value = yamldecode(civo_kubernetes_cluster.k3s.kubeconfig)["users"][0]["name"]
}

output "kubeconf_path" {
  value = local.kubeconf_path
}
