# Operational event routing via EventBridge.

resource "aws_cloudwatch_event_bus" "this" {
  count = var.create_event_bus ? 1 : 0
  name  = var.event_bus_name
  tags = merge(var.tags, {
    Name   = var.event_bus_name
    Module = "observability/eventbridge-observability"
  })
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for r in var.rules : r.name => r }

  name           = each.value.name
  description    = try(each.value.description, null)
  event_bus_name = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : try(each.value.event_bus_name, "default")
  event_pattern  = try(each.value.event_pattern, null)
  schedule_expression = try(each.value.schedule_expression, null)
  state          = try(each.value.state, "ENABLED")
  tags           = merge(var.tags, { Name = each.value.name })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = {
    for item in flatten([
      for r in var.rules : [
        for idx, t in try(r.targets, []) : {
          key       = "${r.name}-${idx}"
          rule_name = r.name
          arn       = t.arn
          target_id = try(t.target_id, "target-${idx}")
          input     = try(t.input, null)
          role_arn  = try(t.role_arn, null)
        }
      ]
    ]) : item.key => item
  }

  rule           = aws_cloudwatch_event_rule.this[each.value.rule_name].name
  event_bus_name = aws_cloudwatch_event_rule.this[each.value.rule_name].event_bus_name
  target_id      = each.value.target_id
  arn            = each.value.arn
  input          = each.value.input
  role_arn       = each.value.role_arn
}
