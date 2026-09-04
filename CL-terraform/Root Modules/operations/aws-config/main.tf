# AWS Config recorder + delivery channel baseline.

resource "aws_config_configuration_recorder" "this" {
  name     = var.recorder_name
  role_arn = var.config_role_arn

  recording_group {
    all_supported                 = var.all_supported
    include_global_resource_types = var.include_global_resource_types
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix
  sns_topic_arn  = var.sns_topic_arn

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.enable_recorder

  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_config_rule" "managed" {
  for_each = var.managed_rules

  name = each.key

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  input_parameters = try(each.value.input_parameters, null)

  depends_on = [aws_config_configuration_recorder.this]
}
