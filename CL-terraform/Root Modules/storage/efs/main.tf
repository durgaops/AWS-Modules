# EFS file system with optional mount targets.

resource "aws_efs_file_system" "this" {
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput_in_mibps : null

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != null ? [1] : []
    content {
      transition_to_ia = var.transition_to_ia
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "storage/efs"
  })
}

resource "aws_efs_mount_target" "this" {
  for_each = var.mount_targets

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value.subnet_id
  security_groups = length(each.value.security_groups) > 0 ? each.value.security_groups : null
  ip_address      = each.value.ip_address
}
