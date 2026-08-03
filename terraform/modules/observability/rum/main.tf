# CloudWatch RUM (Real User Monitoring) app monitor.

resource "aws_rum_app_monitor" "this" {
  name   = var.name
  domain = var.domain

  cw_log_enabled = var.cw_log_enabled

  app_monitor_configuration {
    allow_cookies       = var.allow_cookies
    enable_xray         = var.enable_xray
    session_sample_rate = var.session_sample_rate
    telemetries         = var.telemetries
    guest_role_arn      = var.guest_role_arn
    identity_pool_id    = var.identity_pool_id
    excluded_pages      = var.excluded_pages
    included_pages      = var.included_pages
    favorite_pages      = var.favorite_pages
  }

  dynamic "custom_events" {
    for_each = var.custom_events_status != null ? [1] : []
    content {
      status = var.custom_events_status
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "observability/rum"
  })
}
