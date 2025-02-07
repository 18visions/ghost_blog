data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_route53_zone" "primary" {
  name = var.domain_name
}