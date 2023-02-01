resource "aws_lb" "this" {
  name               = "${var.name}-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = [for subnet in var.subnets : subnet]
 
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name}-lb-tg"
  port     = 80
  target_type = "ip"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/health"
   unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }
}