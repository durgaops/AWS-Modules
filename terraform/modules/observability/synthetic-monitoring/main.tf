# CloudWatch Synthetics canaries.

resource "aws_synthetics_canary" "this" {
  for_each = { for c in var.canaries : c.name => c }

  name                 = each.value.name
  artifact_s3_location = each.value.artifact_s3_location
  execution_role_arn   = each.value.execution_role_arn
  handler              = try(each.value.handler, "index.handler")
  runtime_version      = try(each.value.runtime_version, "syn-nodejs-puppeteer-7.0")
  start_canary         = try(each.value.start_canary, true)
  delete_lambda        = try(each.value.delete_lambda, true)
  zip_file             = try(each.value.zip_file, null)
  s3_bucket            = try(each.value.s3_bucket, null)
  s3_key               = try(each.value.s3_key, null)
  s3_version           = try(each.value.s3_version, null)

  schedule {
    expression          = try(each.value.schedule_expression, "rate(5 minutes)")
    duration_in_seconds = try(each.value.duration_in_seconds, 0)
  }

  run_config {
    timeout_in_seconds = try(each.value.timeout_in_seconds, 60)
    memory_in_mb       = try(each.value.memory_in_mb, 960)
    active_tracing     = try(each.value.active_tracing, true)
    environment_variables = try(each.value.environment_variables, null)
  }

  dynamic "vpc_config" {
    for_each = try(each.value.vpc_config, null) != null ? [each.value.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  success_retention_period = try(each.value.success_retention_period, 31)
  failure_retention_period = try(each.value.failure_retention_period, 31)

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name   = each.value.name
    Module = "observability/synthetic-monitoring"
  })
}
