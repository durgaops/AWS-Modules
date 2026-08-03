locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/data-sync"
    Name      = var.name
  })
}

resource "aws_datasync_task" "this" {
  name                     = var.name
  source_location_arn      = var.source_location_arn
  destination_location_arn = var.destination_location_arn
  cloudwatch_log_group_arn = var.cloudwatch_log_group_arn
  tags                     = local.tags

  options {
    verify_mode            = try(var.options.verify_mode, "ONLY_FILES_TRANSFERRED")
    overwrite_mode         = try(var.options.overwrite_mode, "ALWAYS")
    atime                  = try(var.options.atime, "BEST_EFFORT")
    mtime                  = try(var.options.mtime, "PRESERVE")
    uid                    = try(var.options.uid, "NONE")
    gid                    = try(var.options.gid, "NONE")
    preserve_deleted_files = try(var.options.preserve_deleted_files, "PRESERVE")
    preserve_devices       = try(var.options.preserve_devices, "NONE")
    posix_permissions      = try(var.options.posix_permissions, "NONE")
    bytes_per_second       = try(var.options.bytes_per_second, -1)
  }

  dynamic "schedule" {
    for_each = var.schedule_expression != null ? [var.schedule_expression] : []
    content {
      schedule_expression = schedule.value
    }
  }
}
