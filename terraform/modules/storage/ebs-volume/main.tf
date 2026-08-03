locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/ebs-volume"
    Name      = var.name
  })
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = var.encrypted
      error_message = "EBS encryption is required."
    }
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone    = var.availability_zone
  size                 = var.size
  type                 = var.type
  iops                 = var.iops
  throughput           = var.throughput
  encrypted            = var.encrypted
  kms_key_id           = var.kms_key_id
  snapshot_id          = var.snapshot_id
  multi_attach_enabled = var.multi_attach_enabled
  final_snapshot       = var.final_snapshot
  tags                 = local.tags
  depends_on           = [terraform_data.guardrails]
}
