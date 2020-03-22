variable "okteto_cluster_name" {}
variable "okteto_cluser_user" {}
variable "okteto_cluster_namespace" {}

variable "label" {
  default = "hello-world"
}

variable "image" {
  default = "okteto/hello-world:golang"
}

variable "replicas" {
  type = number
  default = 1
}

variable "service_exposure" {
  default = "ClusterIP"
}

variable "service_internal_port" {
  default = 8080
}

variable "container_port" {
  default = 8080
}