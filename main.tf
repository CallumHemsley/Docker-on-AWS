provider "aws" {
  region  = "eu-west-3"
  profile = "formation"
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  cluster_name = "node-ecs-fargate"
}
