# Standard AWS Identity Center permission sets (IAM Team).

data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn = coalesce(var.instance_arn, tolist(data.aws_ssoadmin_instances.this.arns)[0])
}

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.name
  description      = var.description
  instance_arn     = local.instance_arn
  session_duration = var.session_duration
  relay_state      = var.relay_state
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "identity/identity-center-permission-set"
    Owner     = coalesce(var.owner, "IAM Team")
  })
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = toset(var.managed_policy_arns)

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  managed_policy_arn = each.value
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = { for p in var.customer_managed_policies : p.name => p }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  customer_managed_policy_reference {
    name = each.value.name
    path = try(each.value.path, "/")
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  count = var.inline_policy != null ? 1 : 0

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.inline_policy
}

resource "aws_ssoadmin_permissions_boundary_attachment" "this" {
  count = var.permissions_boundary != null ? 1 : 0

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  permissions_boundary {
    managed_policy_arn = try(var.permissions_boundary.managed_policy_arn, null)

    dynamic "customer_managed_policy_reference" {
      for_each = try(var.permissions_boundary.customer_managed_policy, null) != null ? [var.permissions_boundary.customer_managed_policy] : []
      content {
        name = customer_managed_policy_reference.value.name
        path = try(customer_managed_policy_reference.value.path, "/")
      }
    }
  }
}
