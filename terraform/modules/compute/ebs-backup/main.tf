# EC2 / EBS backup via AWS Backup.

resource "aws_backup_vault" "this" {
  count         = var.create_vault ? 1 : 0
  name          = var.vault_name
  kms_key_arn   = var.kms_key_arn
  force_destroy = var.force_destroy
  tags = merge(var.tags, {
    Name   = var.vault_name
    Module = "compute/ebs-backup"
  })
}

resource "aws_backup_plan" "this" {
  name = var.plan_name

  rule {
    rule_name         = var.rule_name
    target_vault_name = var.create_vault ? aws_backup_vault.this[0].name : var.vault_name
    schedule          = var.schedule
    start_window      = var.start_window
    completion_window = var.completion_window

    lifecycle {
      delete_after = var.delete_after_days
      cold_storage_after = var.cold_storage_after_days
    }

    recovery_point_tags = merge(var.tags, { BackupPlan = var.plan_name })
  }

  tags = merge(var.tags, { Name = var.plan_name })
}

resource "aws_backup_selection" "this" {
  name         = var.selection_name
  plan_id      = aws_backup_plan.this.id
  iam_role_arn = var.backup_role_arn

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = "STRINGEQUALS"
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }

  resources     = length(var.resource_arns) > 0 ? var.resource_arns : null
  not_resources = var.not_resources
}
