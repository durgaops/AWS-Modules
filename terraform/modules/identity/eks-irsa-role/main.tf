# IAM Roles for Service Accounts — IRSA (Kubernetes Platform).

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  oidc_provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
  oidc_provider_arn = coalesce(
    var.oidc_provider_arn,
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_url}"
  )
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "EKSIRSA"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"
      values = [
        for sa in var.service_accounts :
        "system:serviceaccount:${sa.namespace}:${sa.name}"
      ]
    }
  }
}

module "role" {
  source = "../iam-role"

  name                        = var.name
  name_prefix                 = var.name_prefix
  name_regex                  = "^(app|plat)-[a-z0-9-]+$"
  description                 = var.description
  assume_role_policy          = data.aws_iam_policy_document.trust.json
  max_session_duration        = var.max_session_duration
  permissions_boundary_arn    = var.permissions_boundary_arn
  require_permission_boundary = var.require_permission_boundary
  managed_policy_arns         = var.managed_policy_arns
  allow_inline_policies       = var.allow_inline_policies
  inline_policies             = var.inline_policies
  owner                       = coalesce(var.owner, "Kubernetes Platform")
  required_tag_keys           = var.required_tag_keys
  tags = merge(var.tags, {
    Cluster   = var.cluster_name
    AccessVia = "IRSA"
  })
}
