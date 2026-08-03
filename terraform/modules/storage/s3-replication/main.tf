resource "aws_s3_bucket_replication_configuration" "this" {
  bucket = var.source_bucket_id
  role   = var.role_arn

  dynamic "rule" {
    for_each = var.rules
    content {
      id       = rule.value.id
      status   = rule.value.status
      priority = rule.value.priority

      filter {
        prefix = rule.value.prefix
      }

      delete_marker_replication {
        status = rule.value.delete_marker_replication ? "Enabled" : "Disabled"
      }

      destination {
        bucket        = rule.value.destination_bucket_arn
        storage_class = rule.value.storage_class
        account       = rule.value.account

        dynamic "encryption_configuration" {
          for_each = rule.value.replica_kms_key_id != null ? [1] : []
          content {
            replica_kms_key_id = rule.value.replica_kms_key_id
          }
        }

        dynamic "replication_time" {
          for_each = rule.value.metrics_enabled ? [1] : []
          content {
            status = "Enabled"
            time {
              minutes = rule.value.replication_time_minutes
            }
          }
        }

        dynamic "metrics" {
          for_each = rule.value.metrics_enabled ? [1] : []
          content {
            status = "Enabled"
            event_threshold {
              minutes = rule.value.replication_time_minutes
            }
          }
        }
      }
    }
  }
}
