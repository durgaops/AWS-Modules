# Standard CloudWatch Log Group — retention, KMS, naming.

resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  name_prefix       = var.name == null ? var.name_prefix : null
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_arn
  skip_destroy      = var.skip_destroy
  log_group_class   = var.log_group_class

  tags = merge(var.tags, {
    Name      = coalesce(var.name, var.name_prefix)
    ManagedBy = "terraform"
    Module    = "observability/cloudwatch-log-group"
  })
}

resource "aws_cloudwatch_log_stream" "this" {
  for_each       = toset(var.log_streams)
  name           = each.value
  log_group_name = aws_cloudwatch_log_group.this.name
}
