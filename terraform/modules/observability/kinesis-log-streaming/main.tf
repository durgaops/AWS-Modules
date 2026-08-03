# Kinesis-based log pipeline.

resource "aws_kinesis_stream" "this" {
  name             = var.stream_name
  shard_count      = var.stream_mode == "PROVISIONED" ? var.shard_count : null
  retention_period = var.retention_period
  encryption_type  = "KMS"
  kms_key_id       = coalesce(var.kms_key_id, "alias/aws/kinesis")

  stream_mode_details {
    stream_mode = var.stream_mode
  }

  shard_level_metrics = var.shard_level_metrics
  tags = merge(var.tags, {
    Name   = var.stream_name
    Module = "observability/kinesis-log-streaming"
  })
}

resource "aws_kinesis_stream_consumer" "this" {
  for_each   = toset(var.enhanced_consumers)
  name       = each.value
  stream_arn = aws_kinesis_stream.this.arn
}
