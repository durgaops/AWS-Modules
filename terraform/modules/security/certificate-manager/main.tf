# ACM certificates (DNS or email validation).

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  key_algorithm             = var.key_algorithm
  certificate_authority_arn = var.certificate_authority_arn

  dynamic "options" {
    for_each = var.certificate_transparency_logging_preference != null ? [1] : []
    content {
      certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
    }
  }

  tags = merge(var.tags, {
    Name      = var.domain_name
    ManagedBy = "terraform"
    Module    = "security/certificate-manager"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = var.create_route53_records ? {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.wait_for_validation ? 1 : 0
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = var.create_route53_records ? [for r in aws_route53_record.validation : r.fqdn] : var.validation_record_fqdns
}
