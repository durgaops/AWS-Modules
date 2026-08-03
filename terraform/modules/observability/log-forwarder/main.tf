# Forward CW Logs to Splunk, Datadog or another SIEM via Lambda and/or Firehose.

resource "aws_cloudwatch_log_subscription_filter" "this" {
  for_each = { for f in var.forwarders : f.name => f }

  name            = each.value.name
  log_group_name  = each.value.log_group_name
  filter_pattern  = try(each.value.filter_pattern, "")
  destination_arn = coalesce(
    try(each.value.destination_arn, null),
    try(aws_kinesis_firehose_delivery_stream.this[0].arn, null)
  )
  role_arn        = try(each.value.role_arn, var.subscription_role_arn)
  distribution    = try(each.value.distribution, "ByLogStream")
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  count = var.create_firehose ? 1 : 0

  name        = var.firehose_name
  destination = var.firehose_destination

  dynamic "http_endpoint_configuration" {
    for_each = var.firehose_destination == "http_endpoint" ? [1] : []
    content {
      url                = var.siem_endpoint_url
      name               = var.siem_name
      access_key         = var.siem_access_key
      buffering_size     = var.buffering_size
      buffering_interval = var.buffering_interval
      role_arn           = var.firehose_role_arn
      s3_backup_mode     = var.s3_backup_mode

      s3_configuration {
        role_arn           = var.firehose_role_arn
        bucket_arn         = var.backup_bucket_arn
        buffering_size     = var.buffering_size
        buffering_interval = var.buffering_interval
        compression_format = "GZIP"
        kms_key_arn        = var.kms_key_arn
      }

      request_configuration {
        content_encoding = "GZIP"
      }

      cloudwatch_logging_options {
        enabled         = true
        log_group_name  = var.firehose_log_group_name
        log_stream_name = "httpEndpointDelivery"
      }
    }
  }

  dynamic "extended_s3_configuration" {
    for_each = var.firehose_destination == "extended_s3" ? [1] : []
    content {
      role_arn           = var.firehose_role_arn
      bucket_arn         = var.backup_bucket_arn
      buffering_size     = var.buffering_size
      buffering_interval = var.buffering_interval
      compression_format = "GZIP"
      kms_key_arn        = var.kms_key_arn

      cloudwatch_logging_options {
        enabled         = true
        log_group_name  = var.firehose_log_group_name
        log_stream_name = "s3Delivery"
      }
    }
  }

  tags = merge(var.tags, {
    Name   = var.firehose_name
    Module = "observability/log-forwarder"
    SIEM   = var.siem_name
  })
}
