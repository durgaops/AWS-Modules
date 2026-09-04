output "certificate_authority_arn" {
  value = aws_acmpca_certificate_authority.this.arn
}

output "certificate_authority_id" {
  value = aws_acmpca_certificate_authority.this.id
}
