# Network Load Balancer with optional target group and listener.

resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "network"
  internal           = var.internal
  subnets            = var.subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, { Name = var.name, Module = "compute/nlb" })
}

resource "aws_lb_target_group" "this" {
  count = var.create_target_group ? 1 : 0

  name        = coalesce(var.target_group_name, "${var.name}-tg")
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    protocol = var.health_check_protocol
    port     = var.health_check_port
  }

  tags = merge(var.tags, { Name = coalesce(var.target_group_name, "${var.name}-tg"), Module = "compute/nlb" })
}

resource "aws_lb_listener" "this" {
  count = var.create_target_group && var.create_listener ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}
