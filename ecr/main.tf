resource "aws_ecr_repository" "this" {
  name                 = "docker-on-aws/nodejs"
  image_tag_mutability = "MUTABLE"
}