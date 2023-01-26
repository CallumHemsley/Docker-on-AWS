variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "launch_type" {
  description = "launch type of ecs e.g FARGATE"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
}

variable "container_image" {
  description = "Docker image to be launched"
}
