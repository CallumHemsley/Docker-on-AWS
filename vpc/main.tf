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

resource "aws_internet_gateway" "this" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
}
 
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
 
resource "aws_route_table_association" "public" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = element(module.vpc.public_subnets, count.index)
  route_table_id = aws_route_table.public.id
}

#NAT gateway for communicate from private subnet to outside world.
resource "aws_nat_gateway" "this" {
  count         = length(var.vpc_private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(module.vpc.public_subnets, count.index)
  depends_on    = [aws_internet_gateway.this]
}
 
resource "aws_eip" "nat" {
  count = length(var.vpc_private_subnets)
  vpc = true
}

resource "aws_route_table" "private" {
  count  = length(var.vpc_private_subnets)
  vpc_id = module.vpc.vpc_id
}
 
resource "aws_route" "private" {
  count                  = length(compact(var.vpc_private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)
}
 
resource "aws_route_table_association" "private" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = element(module.vpc.private_subnets, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}