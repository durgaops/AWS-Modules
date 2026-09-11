# Private hosted zone for project DNS inside VPC(s).

resource "aws_route53_zone" "this" {
  name = var.zone_name

  dynamic "vpc" {
    for_each = toset(var.vpc_ids)
    content {
      vpc_id = vpc.value
    }
  }

  comment = var.comment
  tags    = merge(var.tags, { Name = var.zone_name, Module = "networking/route53-private-dns" })
}

resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = try(each.value.ttl, 300)
  records = each.value.records
}
