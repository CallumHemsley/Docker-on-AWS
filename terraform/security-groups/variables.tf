variable "name" {
  description = "the name of the stack e.g node"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
}