locals {
  missing_required_tags = [for k in var.required_tag_keys : k if !contains(keys(var.tags), k)]
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/efs"
    Name      = var.name
  })
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = length(local.missing_required_tags) == 0
      error_message = "Missing required tags: ${join(", ", local.missing_required_tags)}"
    }
    precondition {
      condition     = var.encrypted
      error_message = "EFS encryption is required."
    }
  }
}

resource "aws_efs_file_system" "this" {
  creation_token                  = var.name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_arn
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  tags                            = local.tags
  lifecycle_policy { transition_to_ia = var.transition_to_ia }
  depends_on = [terraform_data.guardrails]
}

resource "aws_efs_mount_target" "this" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = var.security_group_ids
}
