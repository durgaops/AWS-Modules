# Application Load Balancer ingress.

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids
  ip_address_type    = var.ip_address_type
  idle_timeout       = var.idle_timeout
  drop_invalid_header_fields = var.drop_invalid_header_fields
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2       = var.enable_http2
  desync_mitigation_mode = var.desync_mitigation_mode

  dynamic "access_logs" {
    for_each = var.access_logs_bucket != null ? [1] : []
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "compute/application-load-balancer"
  })
}

resource "aws_lb_listener" "this" {
  for_each = { for l in var.listeners : "${l.port}-${l.protocol}" => l }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = try(each.value.ssl_policy, null)
  certificate_arn   = try(each.value.certificate_arn, null)

  default_action {
    type             = try(each.value.action_type, "forward")
    target_group_arn = try(each.value.target_group_arn, null)

    dynamic "redirect" {
      for_each = try(each.value.action_type, "forward") == "redirect" ? [each.value.redirect] : []
      content {
        port        = try(redirect.value.port, "443")
        protocol    = try(redirect.value.protocol, "HTTPS")
        status_code = try(redirect.value.status_code, "HTTP_301")
      }
    }

    dynamic "fixed_response" {
      for_each = try(each.value.action_type, "forward") == "fixed-response" ? [each.value.fixed_response] : []
      content {
        content_type = fixed_response.value.content_type
        message_body = try(fixed_response.value.message_body, null)
        status_code  = fixed_response.value.status_code
      }
    }
  }
}
