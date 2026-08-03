output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}
output "certificate_status" {
  value = aws_acm_certificate.this.status
}
output "domain_validation_options" {
  value = aws_acm_certificate.this.domain_validation_options
}
output "validated_certificate_arn" {
  value = try(aws_acm_certificate_validation.this[0].certificate_arn, aws_acm_certificate.this.arn)
}
