# Application Load Balancer with optional target group and HTTP listener.

resource "aws_lb" "this" {
  name                       = var.name
  load_balancer_type         = "application"
  internal                   = var.internal
  subnets                    = var.subnet_ids
  security_groups            = var.security_group_ids
  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout
  enable_http2               = var.enable_http2
  drop_invalid_header_fields = var.drop_invalid_header_fields

  tags = merge(var.tags, {
    Name   = var.name
    Module = "networking/alb"
  })
}

resource "aws_lb_target_group" "this" {
  count = var.create_target_group ? 1 : 0

  name        = coalesce(var.target_group_name, "${var.name}-tg")
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path     = var.health_check_path
    protocol = var.health_check_protocol
    matcher  = var.health_check_matcher
  }

  tags = merge(var.tags, {
    Name   = coalesce(var.target_group_name, "${var.name}-tg")
    Module = "networking/alb"
  })
}

resource "aws_lb_listener" "http" {
  count = var.create_target_group && var.create_http_listener ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}
