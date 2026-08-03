################################################################################
# Cross-account / cross-region backup copy helper.
# Emits policy documents and copy settings for backup-plan / vault policies.
################################################################################

locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/backup-copy"
    Name      = var.name
  })

  copy_action = {
    destination_vault_arn = var.destination_vault_arn
    cold_storage_after    = var.cold_storage_after
    delete_after          = var.delete_after
  }

  destination_principal = var.destination_account_id != null ? "arn:aws:iam::${var.destination_account_id}:root" : "*"
}

data "aws_iam_policy_document" "source_vault_copy" {
  statement {
    sid       = "AllowCopyToDestination"
    effect    = "Allow"
    actions   = ["backup:CopyIntoBackupVault"]
    resources = [var.destination_vault_arn]
    principals {
      type        = "AWS"
      identifiers = [local.destination_principal]
    }
  }
}

data "aws_iam_policy_document" "destination_vault_accept" {
  statement {
    sid       = "AllowCopyFromSource"
    effect    = "Allow"
    actions   = ["backup:CopyIntoBackupVault"]
    resources = [var.destination_vault_arn]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.source_vault_arn]
    }
  }
}

resource "terraform_data" "config" {
  input = {
    name              = var.name
    source_vault_arn  = var.source_vault_arn
    destination_vault = var.destination_vault_arn
    iam_role_arn      = var.iam_role_arn
    copy_action       = local.copy_action
    tags              = local.tags
  }
}
