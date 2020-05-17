locals {
  kubeconf_path = "${path.root}/.kubeconf"
}

resource "civo_kubernetes_cluster" "k3s" {
  name = "dev_k3s"
  num_target_nodes = 3
  target_nodes_size = "g2.small"
  tags = "terraform"

  provisioner "local-exec" {
    command = "echo '${civo_kubernetes_cluster.k3s.kubeconfig}' > ${local.kubeconf_path}"
  }
}
