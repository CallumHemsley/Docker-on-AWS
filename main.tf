locals {
  application_name = "tf_node_aws"
  launch_type      = "FARGATE"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

resource "aws_ecs_cluster" "this" {
  name = local.application_name
}

resource "aws_ecs_service" "this" {
  name        = "node-ecs-service"
  cluster     = aws_ecs_cluster.this.id
  launch_type = local.launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0 //0 so we can kill of tasks when we want
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.this.arn

  network_configuration {
    subnets = module.vpc.public_subnets
  }
}