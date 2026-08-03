# Group-to-account permission assignments (IAM Team).

data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn = coalesce(var.instance_arn, tolist(data.aws_ssoadmin_instances.this.arns)[0])
  identity_store_id = coalesce(
    var.identity_store_id,
    tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  )

  # Expand assignments: each principal × each account
  assignment_map = {
    for item in flatten([
      for a in var.assignments : [
        for account_id in a.account_ids : {
          key                = "${a.principal_type}:${a.principal_id}:${account_id}:${a.permission_set_arn}"
          principal_type     = a.principal_type
          principal_id       = a.principal_id
          account_id         = account_id
          permission_set_arn = a.permission_set_arn
        }
      ]
    ]) : item.key => item
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.assignment_map

  instance_arn       = local.instance_arn
  permission_set_arn = each.value.permission_set_arn
  principal_id       = each.value.principal_id
  principal_type     = each.value.principal_type
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
}
