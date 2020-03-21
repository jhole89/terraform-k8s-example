variable "label" {
  default = "example-app"
}

variable "image" {
  default = "gcr.io/google_containers/echoserver:1.4"
}

variable "service_exposure" {
  default = "NodePort"
}

variable "service_internal_port" {
  default = 8080
}

variable "container_port" {
  default = 8080
}