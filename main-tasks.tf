resource "aws_ecr_repository" "this" {
  name                 = "docker-on-aws/nodejs"
  image_tag_mutability = "MUTABLE"
}

# This role regulates what AWS services the task has access to
resource "aws_iam_role" "ecs_task_role" {
  name = "${local.application_name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# This enables the service to e.g. pull the image from ECR, spin up or deregister tasks etc. 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.application_name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_ecs_task_definition" "this" {
  family                   = "ecs_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = [local.launch_type]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([{
    name      = "${local.application_name}-container"
    image     = "${var.container_image}:latest"
    essential = true
  }])
  # in order to run a task, we have to give our task a task role.
  task_role_arn = aws_iam_role.ecs_task_role.arn
  # task execution role needed due to the fact that the tasks will be executed “serverless” with the Fargate configuration.
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}
