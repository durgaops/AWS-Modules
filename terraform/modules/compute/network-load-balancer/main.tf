# Network Load Balancer workloads.

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  ip_address_type    = var.ip_address_type
  enable_deletion_protection = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

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
    Module = "compute/network-load-balancer"
  })
}

resource "aws_lb_listener" "this" {
  for_each = { for l in var.listeners : "${l.port}-${l.protocol}" => l }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = try(each.value.certificate_arn, null)
  alpn_policy       = try(each.value.alpn_policy, null)
  ssl_policy        = try(each.value.ssl_policy, null)

  default_action {
    type             = "forward"
    target_group_arn = each.value.target_group_arn
  }
}
