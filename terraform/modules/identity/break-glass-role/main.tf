# Controlled emergency (break-glass) access — Security owned.

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "BreakGlassAssume"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    dynamic "condition" {
      for_each = var.allowed_source_ips != null ? [1] : []
      content {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = var.allowed_source_ips
      }
    }
  }
}

module "role" {
  source = "../iam-role"

  name                        = var.name
  name_prefix                 = var.name_prefix
  name_regex                  = "^breakglass-[a-z0-9-]+$"
  description                 = var.description
  assume_role_policy          = data.aws_iam_policy_document.trust.json
  max_session_duration        = var.max_session_duration
  max_session_duration_ceiling = 3600
  permissions_boundary_arn    = var.permissions_boundary_arn
  require_permission_boundary = var.require_permission_boundary
  managed_policy_arns         = var.managed_policy_arns
  allow_inline_policies       = false
  allowed_trust_account_ids   = var.allowed_trust_account_ids
  allowed_trust_principals    = var.trusted_principal_arns
  owner                       = "Security"
  required_tag_keys           = concat(var.required_tag_keys, ["BreakGlass"])
  tags = merge(var.tags, {
    BreakGlass      = "true"
    ApprovalTicket  = var.approval_ticket
    ReviewCadence   = var.review_cadence
  })
}
