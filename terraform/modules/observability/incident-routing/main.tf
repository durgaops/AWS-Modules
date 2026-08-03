# PagerDuty or ServiceNow incident integration via SNS + EventBridge + HTTPS subscriptions.

module "incident_topic" {
  source = "../sns-notification"

  topic_name  = var.topic_name
  kms_key_arn = var.kms_key_arn
  subscriptions = concat(
    var.pagerduty_endpoint != null ? [{
      protocol             = "https"
      endpoint             = var.pagerduty_endpoint
      endpoint_auto_confirms = true
      raw_message_delivery = false
    }] : [],
    var.servicenow_endpoint != null ? [{
      protocol             = "https"
      endpoint             = var.servicenow_endpoint
      endpoint_auto_confirms = true
    }] : [],
    var.extra_subscriptions
  )
  tags = merge(var.tags, {
    Module          = "observability/incident-routing"
    IncidentTooling = var.primary_tool
  })
}

resource "aws_cloudwatch_event_rule" "alarm_to_incident" {
  count       = var.enable_alarm_event_routing ? 1 : 0
  name        = "${var.topic_name}-alarm-routing"
  description = "Route CloudWatch alarm state changes to incident tooling"
  event_pattern = jsonencode({
    source      = ["aws.cloudwatch"]
    detail-type = ["CloudWatch Alarm State Change"]
    detail = {
      state = {
        value = var.alarm_states
      }
    }
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "sns" {
  count     = var.enable_alarm_event_routing ? 1 : 0
  rule      = aws_cloudwatch_event_rule.alarm_to_incident[0].name
  target_id = "incident-sns"
  arn       = module.incident_topic.topic_arn
}

resource "aws_sns_topic_policy" "events" {
  count = var.enable_alarm_event_routing ? 1 : 0
  arn   = module.incident_topic.topic_arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowEventBridgePublish"
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = module.incident_topic.topic_arn
    }]
  })
}
