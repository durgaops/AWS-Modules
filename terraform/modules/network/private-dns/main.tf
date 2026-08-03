# Private DNS zone patterns — wraps hosted-zone for private use + optional records.

module "zone" {
  source = "../route53-hosted-zone"

  zone_name        = var.zone_name
  private_zone     = true
  vpc_associations = var.vpc_associations
  comment          = var.comment
  force_destroy    = var.force_destroy
  tags             = var.tags
}

resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = module.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = try(each.value.ttl, 300)
  records = try(each.value.records, null)

  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = try(alias.value.evaluate_target_health, false)
    }
  }
}
