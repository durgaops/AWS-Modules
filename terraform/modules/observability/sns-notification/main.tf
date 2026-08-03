# Alert topics and subscriptions.

resource "aws_sns_topic" "this" {
  name              = var.topic_name
  display_name      = var.display_name
  kms_master_key_id = var.kms_key_arn
  fifo_topic        = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  tags = merge(var.tags, {
    Name   = var.topic_name
    Module = "observability/sns-notification"
  })
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for s in var.subscriptions : "${s.protocol}:${s.endpoint}" => s }

  topic_arn            = aws_sns_topic.this.arn
  protocol             = each.value.protocol
  endpoint             = each.value.endpoint
  filter_policy        = try(each.value.filter_policy, null)
  filter_policy_scope  = try(each.value.filter_policy_scope, null)
  raw_message_delivery = try(each.value.raw_message_delivery, null)
  endpoint_auto_confirms = try(each.value.endpoint_auto_confirms, null)
}

resource "aws_sns_topic_policy" "this" {
  count  = var.topic_policy != null ? 1 : 0
  arn    = aws_sns_topic.this.arn
  policy = var.topic_policy
}
