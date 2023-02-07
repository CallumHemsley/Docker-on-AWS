output "aws_alb_target_group_arn_blue" {
  value = aws_lb_target_group.blue.arn
}

output "aws_alb_target_group_arn_green" {
  value = aws_lb_target_group.green.arn
}

output "aws_lb_listener" {
  value = aws_lb_listener.this
}