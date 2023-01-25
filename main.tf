locals {
  application_name = "tf_node_aws_fargate"
  launch_type      = "FARGATE"
}

module "vpc" {
  source = "./vpc"
}

module "security_groups" {
  source         = "./security-groups"
  name           = local.application_name
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "ecr" {
  source      = "./ecr"
}

module "ecs" {
  source                      = "./ecs"
  name                        = local.application_name
  launch_type = local.launch_type
  subnets                     = module.vpc.private_subnets
  # aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_image = var.container_image
}