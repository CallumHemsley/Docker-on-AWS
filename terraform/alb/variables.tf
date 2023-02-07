variable "subnets" {
  description = "public subnets for load balancer"
}

variable "alb_security_groups" {
  description = "Created security groups for alb"
}

variable "name" {
  description = "name"
}
variable "vpc_id" {
  description = "the id of the vpc, we've known this.."
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}

variable "traffic_dist_map" {
  description = "map of traffic distribution for blue green deployment"
  type = map
}