# AWS Config recorder and delivery channel.

resource "aws_config_configuration_recorder" "this" {
  name     = var.recorder_name
  role_arn = var.config_role_arn

  recording_group {
    all_supported                 = var.record_all_supported
    include_global_resource_types = var.include_global_resource_types
    resource_types                = var.record_all_supported ? null : var.resource_types
  }

  dynamic "recording_mode" {
    for_each = var.recording_frequency != null ? [1] : []
    content {
      recording_frequency = var.recording_frequency
    }
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix
  s3_kms_key_arn = var.s3_kms_key_arn
  sns_topic_arn  = var.sns_topic_arn

  dynamic "snapshot_properties" {
    for_each = var.snapshot_delivery_frequency != null ? [1] : []
    content {
      delivery_frequency = var.snapshot_delivery_frequency
    }
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.enable_recorder
  depends_on = [aws_config_delivery_channel.this]
}
