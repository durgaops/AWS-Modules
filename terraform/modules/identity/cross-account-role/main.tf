# Standard cross-account access role (IAM / Cloud Platform).

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "CrossAccountAssume"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }

    dynamic "condition" {
      for_each = var.require_external_id ? [1] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [var.external_id]
      }
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

module "role" {
  source = "../iam-role"

  name                         = var.name
  name_prefix                  = var.name_prefix
  name_regex                   = var.name_regex
  description                  = var.description
  assume_role_policy           = data.aws_iam_policy_document.trust.json
  max_session_duration         = var.max_session_duration
  permissions_boundary_arn     = var.permissions_boundary_arn
  require_permission_boundary  = var.require_permission_boundary
  managed_policy_arns          = var.managed_policy_arns
  allow_inline_policies        = false
  allowed_trust_account_ids    = var.allowed_trust_account_ids
  allowed_trust_principals     = var.trusted_principal_arns
  owner                        = coalesce(var.owner, "IAM / Cloud Platform")
  required_tag_keys            = var.required_tag_keys
  tags                         = var.tags
}
