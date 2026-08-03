output "zone_id" {
  value = module.zone.zone_id
}

output "zone_arn" {
  value = module.zone.zone_arn
}

output "record_names" {
  value = { for k, r in aws_route53_record.this : k => r.fqdn }
}
