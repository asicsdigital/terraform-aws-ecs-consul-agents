variable "consul_image" {
  description = "Image to use when deploying consul, defaults to the hashicorp consul image"
  default     = "consul:latest"
}

variable "consul_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container, defaults 32"
  default     = "32"
}

variable "definitions" {
  type        = "list"
  description = "List of Consul Service and Health Check Definitions"
  default     = []
}

variable "ecs_cluster" {
  description = "EC2 Container Service cluster in which the service will be deployed (must already exist, the module will not create it)."
}

variable "healthcheck_image" {
  default     = "fitnesskeeper/consul-healthchecks"
  description = "Image to use when deploying health check agent, defaults to fitnesskeeper/consul-healthchecks:latest image"
}

variable "healthcheck_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container, defaults 32"
  default     = "32"
}

variable "iam_path" {
  default     = "/"
  description = "IAM path, this is useful when creating resources with the same name across multiple regions. Defaults to /"
}

variable "registrator_image" {
  default     = "gliderlabs/registrator:latest"
  description = "Image to use when deploying registrator agent, defaults to the gliderlabs registrator:latest image"
}

variable "registrator_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container, defaults 32"
  default     = "32"
}
