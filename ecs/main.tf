# This role regulates what AWS services the task has access to
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecsTaskRole"

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
  name = "${var.name}-ecsTaskExecutionRole"

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

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-logs" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::056984988198:policy/cloudwatch-logs-write"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-logs" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::056984988198:policy/cloudwatch-logs-write"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "ecs_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([{
    name      = "${var.name}-container"
    image     = "${var.container_image}:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration= {
        logDriver= "awslogs",
        options= {
            awslogs-create-group= "true",
            awslogs-group= "callums-node-logs",
            awslogs-region= "eu-west-3",
            awslogs-stream-prefix= "awslogs-example"
        }
    },
  }])
  # in order to run a task, we have to give our task a task role.
  task_role_arn = aws_iam_role.ecs_task_role.arn
  # task execution role needed due to the fact that the tasks will be executed “serverless” with the Fargate configuration.
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}


resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "aws_ecs_service" "this" {
  name        = "node-ecs-service"
  cluster     = aws_ecs_cluster.this.id
  launch_type = var.launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0 //0 so we can kill of tasks when we want
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.this.arn

  network_configuration {
    subnets = var.subnets
    security_groups  = var.ecs_service_security_groups
    assign_public_ip = false
  }
}