variable "role" {
  type = string
  description = "The node role. Must be one of master | slave"
  default = "slave"
}

variable "namespace" {
  type = string
  description = "k8s namespace"
}

variable "replicas" {
  type = number
  default = 1
}

variable "container_port" {
  type = number
  description = "The container port"
}

variable "service_port" {
  type = number
  description = "The service port"
}

variable "env" {
  type = list(map(string))
  default = []
}
