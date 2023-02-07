locals {
  application_name = "tf-node-aws-fargate"
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

module "alb" {
  source = "./alb"
  subnets = module.vpc.public_subnets
  alb_security_groups = [module.security_groups.alb]
  name = local.application_name
  vpc_id         = module.vpc.vpc_id
  traffic_distribution = var.traffic_distribution
  traffic_dist_map = local.traffic_dist_map
}

module "ecr" {
  source = "./ecr"
}

module "ecs_blue" {
  source                      = "./ecs"
  name                        = "${local.application_name}-blue"
  launch_type                 = local.launch_type
  subnets                     = module.vpc.private_subnets
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_image             = var.container_image
  aws_alb_target_group_arn = module.alb.aws_alb_target_group_arn_blue
  aws_lb_listener = module.alb.aws_lb_listener
  image_version = "1.0.1"
}

module "ecs_green" {
  source                      = "./ecs"
  name                        = "${local.application_name}-green"
  launch_type                 = local.launch_type
  subnets                     = module.vpc.private_subnets
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_image             = var.container_image
  aws_alb_target_group_arn = module.alb.aws_alb_target_group_arn_green
  aws_lb_listener = module.alb.aws_lb_listener
  image_version = "1.0.2"
}