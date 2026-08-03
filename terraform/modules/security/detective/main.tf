# Amazon Detective security investigation capability.

resource "aws_detective_graph" "this" {
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/detective"
  })
}

resource "aws_detective_organization_admin_account" "this" {
  count            = var.delegate_admin_account_id != null ? 1 : 0
  account_id       = var.delegate_admin_account_id
}

resource "aws_detective_member" "this" {
  for_each = { for m in var.member_accounts : m.account_id => m }

  account_id    = each.value.account_id
  email_address = each.value.email_address
  graph_arn     = aws_detective_graph.this.graph_arn
  message       = try(each.value.message, null)
  disable_email_notification = try(each.value.disable_email_notification, true)
}
