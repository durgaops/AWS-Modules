# Standard managed and custom Config rules.

resource "aws_config_config_rule" "managed" {
  for_each = { for r in var.managed_rules : r.name => r }

  name        = each.value.name
  description = try(each.value.description, null)

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  input_parameters = try(each.value.input_parameters, null)
  maximum_execution_frequency = try(each.value.maximum_execution_frequency, null)

  dynamic "scope" {
    for_each = try(each.value.scope, null) != null ? [each.value.scope] : []
    content {
      compliance_resource_id    = try(scope.value.compliance_resource_id, null)
      compliance_resource_types = try(scope.value.compliance_resource_types, null)
      tag_key                   = try(scope.value.tag_key, null)
      tag_value                 = try(scope.value.tag_value, null)
    }
  }

  tags = merge(var.tags, { Name = each.value.name })
}

resource "aws_config_config_rule" "custom" {
  for_each = { for r in var.custom_rules : r.name => r }

  name        = each.value.name
  description = try(each.value.description, null)

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = each.value.lambda_arn

    dynamic "source_detail" {
      for_each = try(each.value.source_details, [{ message_type = "ConfigurationItemChangeNotification" }])
      content {
        event_source = try(source_detail.value.event_source, "aws.config")
        message_type = source_detail.value.message_type
        maximum_execution_frequency = try(source_detail.value.maximum_execution_frequency, null)
      }
    }
  }

  input_parameters = try(each.value.input_parameters, null)

  tags = merge(var.tags, { Name = each.value.name })
}
