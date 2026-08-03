# Security findings fan-out to SNS (SIEM / ServiceNow subscribe downstream).

resource "aws_sns_topic" "this" {
  name              = var.topic_name
  kms_master_key_id = var.kms_key_arn
  tags = merge(var.tags, {
    Name      = var.topic_name
    ManagedBy = "terraform"
    Module    = "security/security-notifications"
  })
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for s in var.subscriptions : "${s.protocol}:${s.endpoint}" => s }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
  filter_policy = try(each.value.filter_policy, null)
  raw_message_delivery = try(each.value.raw_message_delivery, null)
}

resource "aws_cloudwatch_event_rule" "security_hub" {
  count       = var.enable_security_hub_forwarding ? 1 : 0
  name        = "${var.topic_name}-securityhub"
  description = "Forward Security Hub findings"
  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = var.security_hub_severity_labels
        }
      }
    }
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "security_hub" {
  count     = var.enable_security_hub_forwarding ? 1 : 0
  rule      = aws_cloudwatch_event_rule.security_hub[0].name
  target_id = "security-notifications"
  arn       = aws_sns_topic.this.arn
}

resource "aws_cloudwatch_event_rule" "guardduty" {
  count       = var.enable_guardduty_forwarding ? 1 : 0
  name        = "${var.topic_name}-guardduty"
  description = "Forward GuardDuty findings"
  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "guardduty" {
  count     = var.enable_guardduty_forwarding ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty[0].name
  target_id = "security-notifications"
  arn       = aws_sns_topic.this.arn
}

resource "aws_sns_topic_policy" "events" {
  arn = aws_sns_topic.this.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowEventBridge"
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = aws_sns_topic.this.arn
    }]
  })
}
