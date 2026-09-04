output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "certificate_domain_name" {
  value = aws_acm_certificate.this.domain_name
}

output "certificate_status" {
  value = aws_acm_certificate.this.status
}

output "domain_validation_options" {
  description = "DNS validation records to create in your hosted zone (name, type, value)"
  value       = aws_acm_certificate.this.domain_validation_options
}

output "dns_validation_records" {
  description = "Simplified DNS CNAME records needed for ACM DNS validation"
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}
