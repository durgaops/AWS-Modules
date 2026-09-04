# IAM Identity Center permission set + account assignments.
# Instance ARN typically comes from the Identity Center console / data source.

data "aws_ssoadmin_instances" "this" {
  count = var.identity_store_id == null || var.instance_arn == null ? 1 : 0
}

locals {
  instance_arn      = coalesce(var.instance_arn, try(tolist(data.aws_ssoadmin_instances.this[0].arns)[0], null))
  identity_store_id = coalesce(var.identity_store_id, try(tolist(data.aws_ssoadmin_instances.this[0].identity_store_ids)[0], null))
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  name             = each.key
  description      = try(each.value.description, null)
  instance_arn     = local.instance_arn
  session_duration = try(each.value.session_duration, "PT8H")
  relay_state      = try(each.value.relay_state, null)
  tags             = merge(var.tags, try(each.value.tags, {}), { Module = "foundation/identity-center" })
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = {
    for item in flatten([
      for ps_name, ps in var.permission_sets : [
        for policy in try(ps.managed_policy_arns, []) : {
          key         = "${ps_name}|${policy}"
          ps_name     = ps_name
          policy_arn  = policy
        }
      ]
    ]) : item.key => item
  }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = {
    for item in flatten([
      for a_name, a in var.account_assignments : [{
        key                = a_name
        permission_set     = a.permission_set
        principal_id       = a.principal_id
        principal_type     = a.principal_type
        target_id          = a.target_account_id
      }]
    ]) : item.key => item
  }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_id       = each.value.principal_id
  principal_type     = each.value.principal_type
  target_id          = each.value.target_id
  target_type        = "AWS_ACCOUNT"
}
