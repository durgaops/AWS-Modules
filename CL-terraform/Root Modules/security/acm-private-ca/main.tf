# ACM Private Certificate Authority (root or subordinate).

resource "aws_acmpca_certificate_authority" "this" {
  type       = var.type
  usage_mode = var.usage_mode

  certificate_authority_configuration {
    key_algorithm     = var.key_algorithm
    signing_algorithm = var.signing_algorithm

    subject {
      common_name         = var.subject.common_name
      organization        = try(var.subject.organization, null)
      organizational_unit = try(var.subject.organizational_unit, null)
      country             = try(var.subject.country, null)
      state               = try(var.subject.state, null)
      locality            = try(var.subject.locality, null)
    }
  }

  permanent_deletion_time_in_days = var.permanent_deletion_time_in_days

  tags = merge(var.tags, { Name = var.name, Module = "security/acm-private-ca" })
}
