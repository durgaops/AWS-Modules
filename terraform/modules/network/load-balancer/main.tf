# ALB/NLB reusable configuration.

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.load_balancer_type == "application" ? var.security_group_ids : null
  subnets            = var.subnet_ids
  ip_address_type    = var.ip_address_type

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.load_balancer_type == "application" ? var.idle_timeout : null

  dynamic "access_logs" {
    for_each = var.access_logs_bucket != null ? [1] : []
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = each.key
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = try(each.value.target_type, "instance")

  health_check {
    enabled             = true
    path                = try(each.value.health_check_path, null)
    protocol            = try(each.value.health_check_protocol, each.value.protocol)
    healthy_threshold   = try(each.value.healthy_threshold, 3)
    unhealthy_threshold = try(each.value.unhealthy_threshold, 3)
    matcher             = try(each.value.matcher, null)
  }

  tags = merge(var.tags, { Name = each.key })
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = try(each.value.ssl_policy, null)
  certificate_arn   = try(each.value.certificate_arn, null)

  default_action {
    type             = try(each.value.action_type, "forward")
    target_group_arn = try(aws_lb_target_group.this[each.value.target_group_key].arn, null)

    dynamic "redirect" {
      for_each = try(each.value.action_type, "forward") == "redirect" ? [each.value.redirect] : []
      content {
        port        = try(redirect.value.port, "443")
        protocol    = try(redirect.value.protocol, "HTTPS")
        status_code = try(redirect.value.status_code, "HTTP_301")
      }
    }
  }
}
