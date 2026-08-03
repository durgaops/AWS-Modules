# Organization-level CloudTrail (management + optional data events).

resource "aws_cloudtrail" "this" {
  name                          = var.name
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = true
  enable_log_file_validation    = var.enable_log_file_validation
  kms_key_id                    = var.kms_key_arn
  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn
  sns_topic_name                = var.sns_topic_name
  enable_logging                = var.enable_logging

  dynamic "event_selector" {
    for_each = var.event_selectors
    content {
      read_write_type           = try(event_selector.value.read_write_type, "All")
      include_management_events = try(event_selector.value.include_management_events, true)

      dynamic "data_resource" {
        for_each = try(event_selector.value.data_resources, [])
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  dynamic "insight_selector" {
    for_each = var.insight_selectors
    content {
      insight_type = insight_selector.value
    }
  }

  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/cloudtrail-organization"
  })
}
