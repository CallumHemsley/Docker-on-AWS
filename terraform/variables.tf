locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}

variable "container_image" {
  description = "image uri inside your ecr registry"
  type        = string
  default     = "056984988198.dkr.ecr.eu-west-3.amazonaws.com/docker-on-aws-tf/nodejs"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 80
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/health"
}