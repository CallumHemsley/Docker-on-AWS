output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "vpc private subnets"
  value = module.vpc.private_subnets
}