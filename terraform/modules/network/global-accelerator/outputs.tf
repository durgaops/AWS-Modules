output "accelerator_arn" {
  value = aws_globalaccelerator_accelerator.this.id
}

output "dns_name" {
  value = aws_globalaccelerator_accelerator.this.dns_name
}

output "hosted_zone_id" {
  value = aws_globalaccelerator_accelerator.this.hosted_zone_id
}

output "static_ips" {
  value = flatten([for ipset in aws_globalaccelerator_accelerator.this.ip_sets : ipset.ip_addresses])
}
