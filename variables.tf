variable "container_image" {
  description = "image uri inside your ecr registry"
  type        = string
  default     = "056984988198.dkr.ecr.eu-west-3.amazonaws.com/docker-on-aws/nodejs"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8080
}