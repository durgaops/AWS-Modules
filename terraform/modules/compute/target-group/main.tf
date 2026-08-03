# Reusable target group configuration.

resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  protocol_version = var.protocol_version
  vpc_id      = var.vpc_id
  target_type = var.target_type
  deregistration_delay = var.deregistration_delay
  slow_start  = var.slow_start

  health_check {
    enabled             = true
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
  }

  dynamic "stickiness" {
    for_each = var.stickiness != null ? [var.stickiness] : []
    content {
      type            = stickiness.value.type
      cookie_duration = try(stickiness.value.cookie_duration, null)
      enabled         = try(stickiness.value.enabled, true)
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "compute/target-group"
  })
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for t in var.targets : coalesce(try(t.target_id, null), try(t.id, null)) => t }

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = coalesce(try(each.value.target_id, null), try(each.value.id, null))
  port             = try(each.value.port, var.port)
  availability_zone = try(each.value.availability_zone, null)
}
