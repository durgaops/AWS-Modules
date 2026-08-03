# Application and service workload identities (Security / Platform).

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "WorkloadAssume"
    actions = var.trust_actions

    dynamic "principals" {
      for_each = length(var.trusted_service_principals) > 0 ? [1] : []
      content {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }

    dynamic "principals" {
      for_each = length(var.trusted_aws_principals) > 0 ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_aws_principals
      }
    }

    dynamic "condition" {
      for_each = var.trust_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

module "role" {
  source = "../iam-role"

  name                        = var.name
  name_prefix                 = var.name_prefix
  name_regex                  = var.name_regex
  description                 = var.description
  assume_role_policy          = data.aws_iam_policy_document.trust.json
  max_session_duration        = var.max_session_duration
  permissions_boundary_arn    = var.permissions_boundary_arn
  require_permission_boundary = var.require_permission_boundary
  managed_policy_arns         = var.managed_policy_arns
  allow_inline_policies       = var.allow_inline_policies
  inline_policies             = var.inline_policies
  create_instance_profile     = var.create_instance_profile
  allowed_trust_account_ids   = var.allowed_trust_account_ids
  owner                       = coalesce(var.owner, "Security / Platform")
  required_tag_keys           = var.required_tag_keys
  tags                        = merge(var.tags, { Workload = var.workload_name })
}
