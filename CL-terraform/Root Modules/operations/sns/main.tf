# SNS topic with optional subscriptions for ops alerting.

resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.kms_key_id
  display_name      = var.display_name

  tags = merge(var.tags, { Name = var.name, Module = "operations/sns" })
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for s in var.subscriptions : "${s.protocol}:${s.endpoint}" => s }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}
