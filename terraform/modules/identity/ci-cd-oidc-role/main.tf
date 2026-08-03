# OIDC access for GitHub, GitLab, or other CI/CD tools (DevSecOps).

data "aws_caller_identity" "current" {}

locals {
  # Provider URL without https://
  oidc_provider_url = replace(var.oidc_provider_url, "https://", "")
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_oidc_provider ? 1 : 0

  url             = startswith(var.oidc_provider_url, "https://") ? var.oidc_provider_url : "https://${var.oidc_provider_url}"
  client_id_list  = var.oidc_client_ids
  thumbprint_list = var.oidc_thumbprints
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "identity/ci-cd-oidc-role"
  })
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "CICDOidcAssume"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        var.create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : var.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"
      values   = var.oidc_audiences
    }

    dynamic "condition" {
      for_each = length(var.allowed_subjects) > 0 ? [1] : []
      content {
        test     = var.subject_condition_operator
        variable = "${local.oidc_provider_url}:sub"
        values   = var.allowed_subjects
      }
    }
  }
}

module "role" {
  source = "../iam-role"

  name                        = var.name
  name_prefix                 = var.name_prefix
  name_regex                  = "^cicd-[a-z0-9-]+$"
  description                 = var.description
  assume_role_policy          = data.aws_iam_policy_document.trust.json
  max_session_duration        = var.max_session_duration
  permissions_boundary_arn    = var.permissions_boundary_arn
  require_permission_boundary = var.require_permission_boundary
  managed_policy_arns         = var.managed_policy_arns
  allow_inline_policies       = var.allow_inline_policies
  inline_policies             = var.inline_policies
  owner                       = coalesce(var.owner, "DevSecOps")
  required_tag_keys           = var.required_tag_keys
  tags                        = merge(var.tags, { Pipeline = var.pipeline_name })
}
