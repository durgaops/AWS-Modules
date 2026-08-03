# Resource or account quarantine automation scaffolding.
# Applies restrictive SCP-like tags + EventBridge trigger to quarantine Lambda.

resource "aws_cloudwatch_event_rule" "quarantine_trigger" {
  name        = var.rule_name
  description = "Triggers quarantine automation"
  event_pattern = var.event_pattern != null ? var.event_pattern : jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = { Label = var.trigger_severity_labels }
        Workflow = { Status = ["NEW"] }
      }
    }
  })
  tags = merge(var.tags, { Name = var.rule_name })
}

resource "aws_cloudwatch_event_target" "quarantine_lambda" {
  rule      = aws_cloudwatch_event_rule.quarantine_trigger.name
  target_id = "quarantine"
  arn       = var.quarantine_lambda_arn

  input_transformer {
    input_paths = {
      findingId = "$.detail.findings[0].Id"
      accountId = "$.detail.findings[0].AwsAccountId"
      resource  = "$.detail.findings[0].Resources[0].Id"
    }
    input_template = <<EOF
{
  "action": "quarantine",
  "finding_id": <findingId>,
  "account_id": <accountId>,
  "resource_arn": <resource>,
  "quarantine_sg_id": "${var.quarantine_security_group_id}",
  "notify_topic_arn": "${var.notify_topic_arn}"
}
EOF
  }
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowExecutionFromEventBridgeQuarantine"
  action        = "lambda:InvokeFunction"
  function_name = var.quarantine_lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.quarantine_trigger.arn
}
