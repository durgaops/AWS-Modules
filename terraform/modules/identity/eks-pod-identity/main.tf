# EKS Pod Identity — modern alternative to IRSA (Kubernetes Platform).

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "EKSPodIdentity"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
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
    AccessVia = "EKSPodIdentity"
  })
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = { for sa in var.service_accounts : "${sa.namespace}/${sa.name}" => sa }

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.name
  role_arn        = module.role.role_arn
  tags            = var.tags
}
