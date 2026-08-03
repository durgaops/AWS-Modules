locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/backup-plan"
    Name      = var.name
  })
}

resource "aws_backup_plan" "this" {
  name = var.name
  tags = local.tags

  rule {
    rule_name                = var.rule_name
    target_vault_name        = var.target_vault_name
    schedule                 = var.schedule
    start_window             = var.start_window
    completion_window        = var.completion_window
    enable_continuous_backup = var.enable_continuous_backup

    lifecycle {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }

    dynamic "copy_action" {
      for_each = var.copy_actions
      content {
        destination_vault_arn = copy_action.value.destination_vault_arn
        lifecycle {
          cold_storage_after = copy_action.value.cold_storage_after
          delete_after       = copy_action.value.delete_after
        }
      }
    }
  }
}

resource "aws_backup_selection" "this" {
  name         = var.selection_name
  plan_id      = aws_backup_plan.this.id
  iam_role_arn = var.iam_role_arn
  resources    = length(var.resources) > 0 ? var.resources : null

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value.type
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }
}
