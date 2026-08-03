# Firehose delivery to S3, SIEM or analytics platform.

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = var.destination

  dynamic "extended_s3_configuration" {
    for_each = var.destination == "extended_s3" ? [1] : []
    content {
      role_arn            = var.role_arn
      bucket_arn          = var.s3_bucket_arn
      prefix              = var.s3_prefix
      error_output_prefix = var.s3_error_prefix
      buffering_size      = var.buffering_size
      buffering_interval  = var.buffering_interval
      compression_format  = var.compression_format
      kms_key_arn         = var.kms_key_arn

      dynamic "processing_configuration" {
        for_each = var.processor_lambda_arn != null ? [1] : []
        content {
          enabled = true
          processors {
            type = "Lambda"
            parameters {
              parameter_name  = "LambdaArn"
              parameter_value = var.processor_lambda_arn
            }
          }
        }
      }

      cloudwatch_logging_options {
        enabled         = var.cloudwatch_log_group_name != null
        log_group_name  = var.cloudwatch_log_group_name
        log_stream_name = "S3Delivery"
      }
    }
  }

  dynamic "http_endpoint_configuration" {
    for_each = var.destination == "http_endpoint" ? [1] : []
    content {
      url                = var.http_endpoint_url
      name               = var.http_endpoint_name
      access_key         = var.http_endpoint_access_key
      buffering_size     = var.buffering_size
      buffering_interval = var.buffering_interval
      role_arn           = var.role_arn
      s3_backup_mode     = var.s3_backup_mode

      s3_configuration {
        role_arn           = var.role_arn
        bucket_arn         = var.s3_bucket_arn
        buffering_size     = var.buffering_size
        buffering_interval = var.buffering_interval
        compression_format = var.compression_format
        kms_key_arn        = var.kms_key_arn
      }
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "observability/firehose-log-delivery"
  })
}
