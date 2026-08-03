# EventBridge + Lambda corrective controls (remediation framework).

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for r in var.remediation_rules : r.name => r }

  name           = each.value.name
  description    = try(each.value.description, "Event-driven remediation")
  event_pattern  = try(each.value.event_pattern, null)
  event_bus_name = try(each.value.event_bus_name, "default")
  schedule_expression = try(each.value.schedule_expression, null)
  state          = try(each.value.state, "ENABLED")
  tags           = merge(var.tags, { Name = each.value.name })
}

resource "aws_cloudwatch_event_target" "lambda" {
  for_each = { for r in var.remediation_rules : r.name => r }

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "remediation-lambda"
  arn       = each.value.lambda_arn
}

resource "aws_lambda_permission" "allow_events" {
  for_each = { for r in var.remediation_rules : r.name => r }

  statement_id  = "AllowExecutionFromEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[each.key].arn
}
