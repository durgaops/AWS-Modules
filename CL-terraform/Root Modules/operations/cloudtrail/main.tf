# CloudTrail trail for account/org audit logging.

resource "aws_cloudtrail" "this" {
  name                          = var.name
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_log_file_validation    = var.enable_log_file_validation
  kms_key_id                    = var.kms_key_id
  is_organization_trail         = var.is_organization_trail
  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn

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

  tags = merge(var.tags, { Name = var.name, Module = "operations/cloudtrail" })
}
