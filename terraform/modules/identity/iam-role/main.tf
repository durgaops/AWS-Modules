################################################################################
# Standard assumable IAM role with Cloud COE guardrails:
# - Naming convention
# - Maximum session duration
# - Approved trust principals
# - Required tags / ownership metadata
# - Optional permission boundary
# - Inline-policy restrictions
# - Cross-account trust validation
################################################################################

locals {
  required_tag_keys = toset(var.required_tag_keys)

  missing_required_tags = [
    for k in local.required_tag_keys : k if !contains(keys(var.tags), k)
  ]

  # Normalize principal ARNs / service names from trust policy statements
  trust_statements = try(jsondecode(var.assume_role_policy).Statement, [])

  extracted_principals = distinct(flatten([
    for stmt in local.trust_statements : concat(
      try(tolist(stmt.Principal.AWS), try([stmt.Principal.AWS], [])),
      try(tolist(stmt.Principal.Service), try([stmt.Principal.Service], [])),
      try(tolist(stmt.Principal.Federated), try([stmt.Principal.Federated], []))
    ) if try(stmt.Principal, null) != null
  ]))

  # Account IDs found in AWS principal ARNs (arn:aws:iam::123456789012:...)
  trusted_account_ids = distinct(compact([
    for p in local.extracted_principals :
    try(regex("^arn:aws:iam::([0-9]{12}):", p)[0], null)
  ]))

  unapproved_accounts = [
    for a in local.trusted_account_ids : a
    if length(var.allowed_trust_account_ids) > 0 && !contains(var.allowed_trust_account_ids, a)
  ]

  unapproved_principals = [
    for p in local.extracted_principals : p
    if length(var.allowed_trust_principals) > 0 && !contains(var.allowed_trust_principals, p)
  ]

  role_name = var.name_prefix != null ? "${var.name_prefix}${var.name}" : var.name

  ownership_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "identity/iam-role"
    },
    var.owner != null ? { Owner = var.owner } : {},
    var.cost_center != null ? { CostCenter = var.cost_center } : {},
    var.data_classification != null ? { DataClassification = var.data_classification } : {}
  )

  tags = merge(local.ownership_tags, var.tags, { Name = local.role_name })
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = can(regex(var.name_regex, local.role_name))
      error_message = "Role name '${local.role_name}' does not match required pattern: ${var.name_regex}"
    }

    precondition {
      condition     = length(local.missing_required_tags) == 0
      error_message = "Missing required tags: ${join(", ", local.missing_required_tags)}"
    }

    precondition {
      condition     = var.max_session_duration >= 3600 && var.max_session_duration <= var.max_session_duration_ceiling
      error_message = "max_session_duration must be between 3600 and ${var.max_session_duration_ceiling} seconds."
    }

    precondition {
      condition     = length(local.unapproved_accounts) == 0
      error_message = "Cross-account trust not allowed for account(s): ${join(", ", local.unapproved_accounts)}"
    }

    precondition {
      condition     = length(local.unapproved_principals) == 0
      error_message = "Trust principal(s) not in allow-list: ${join(", ", local.unapproved_principals)}"
    }

    precondition {
      condition     = !var.require_permission_boundary || var.permissions_boundary_arn != null
      error_message = "permissions_boundary_arn is required (require_permission_boundary=true)."
    }

    precondition {
      condition     = var.allow_inline_policies || length(var.inline_policies) == 0
      error_message = "Inline policies are disabled for this role. Use managed policies instead."
    }

    precondition {
      condition     = length(var.inline_policies) <= var.max_inline_policies
      error_message = "Too many inline policies (${length(var.inline_policies)}). Max allowed: ${var.max_inline_policies}."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  path                 = var.path
  description          = var.description
  assume_role_policy   = var.assume_role_policy
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies
  tags                 = local.tags

  depends_on = [terraform_data.guardrails]
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.allow_inline_policies ? var.inline_policies : {}

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = local.role_name
  path = var.path
  role = aws_iam_role.this.name
  tags = local.tags
}
