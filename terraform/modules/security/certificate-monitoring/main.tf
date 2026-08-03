# Certificate expiration alerts via EventBridge + SNS.

resource "aws_cloudwatch_event_rule" "acm_expiry" {
  name        = var.rule_name
  description = "Alert on ACM certificate approaching expiration"
  event_pattern = jsonencode({
    source      = ["aws.acm"]
    detail-type = ["ACM Certificate Approaching Expiration"]
  })
  tags = merge(var.tags, { Name = var.rule_name })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.acm_expiry.name
  target_id = "certificate-expiry-sns"
  arn       = var.sns_topic_arn
}

resource "aws_sns_topic_policy" "allow_events" {
  count = var.manage_sns_topic_policy ? 1 : 0
  arn   = var.sns_topic_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowEventBridgePublish"
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = var.sns_topic_arn
      Condition = {
        ArnEquals = { "aws:SourceArn" = aws_cloudwatch_event_rule.acm_expiry.arn }
      }
    }]
  })
}

resource "aws_cloudwatch_metric_alarm" "days_to_expiry" {
  for_each = { for c in var.certificate_arns : c => c }

  alarm_name          = "${var.alarm_name_prefix}-${substr(md5(each.value), 0, 8)}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DaysToExpiry"
  namespace           = "AWS/CertificateManager"
  period              = 86400
  statistic           = "Minimum"
  threshold           = var.expiry_threshold_days
  alarm_description   = "ACM certificate nearing expiration"
  alarm_actions       = [var.sns_topic_arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    CertificateArn = each.value
  }

  tags = var.tags
}
