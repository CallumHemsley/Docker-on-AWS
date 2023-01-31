output "ecs_tasks" {
  value = aws_security_group.ecs_tasks.id
}
output "alb" {
  value = aws_security_group.alb.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}