#Setting up Aws-Route53 for my domain
variable "domain_name"{
    default = "rawlings.com.ng"
    type = string
    description = "domain name"
}

resource "aws_route53-zone" "my_domain" {
  name = var.domain_name

  tags={
    environment= "dev"
  }
}

resource "aws_route53_record" "web_domain" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "terraform.test.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.elb.dns_name
    zone_id                = aws_elb.elb.zone_id
    evaluate_target_health = true
  }
}