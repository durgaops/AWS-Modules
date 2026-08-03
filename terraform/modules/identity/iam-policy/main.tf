# Managed IAM policy creation with naming + required tag enforcement.

locals {
  missing_required_tags = [
    for k in var.required_tag_keys : k if !contains(keys(var.tags), k)
  ]

  policy_name = var.name_prefix != null ? "${var.name_prefix}${var.name}" : var.name

  tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "identity/iam-policy"
    },
    var.owner != null ? { Owner = var.owner } : {},
    var.tags,
    { Name = local.policy_name }
  )
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = can(regex(var.name_regex, local.policy_name))
      error_message = "Policy name '${local.policy_name}' does not match: ${var.name_regex}"
    }

    precondition {
      condition     = length(local.missing_required_tags) == 0
      error_message = "Missing required tags: ${join(", ", local.missing_required_tags)}"
    }

    precondition {
      condition     = length(var.policy_document) > 0
      error_message = "policy_document must not be empty."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  path        = var.path
  description = var.description
  policy      = var.policy_document
  tags        = local.tags

  depends_on = [terraform_data.guardrails]
}
