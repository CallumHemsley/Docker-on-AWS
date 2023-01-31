variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
  default = "password"
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}


variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "rds_security_group_id" {
  description = "Id for security group of rds"
}
