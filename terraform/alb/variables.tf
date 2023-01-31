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