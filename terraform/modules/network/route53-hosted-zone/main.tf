resource "aws_route53_zone" "this" {
  name          = var.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy

  dynamic "vpc" {
    for_each = var.private_zone ? var.vpc_associations : []
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = try(vpc.value.vpc_region, null)
    }
  }

  tags = merge(var.tags, { Name = var.zone_name })
}
