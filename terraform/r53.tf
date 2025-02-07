resource "aws_route53_record" "ghost-web-001" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ghost-web-001.public_ip]
}