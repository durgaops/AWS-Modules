output "inbound_endpoint_id" {
  value = try(aws_route53_resolver_endpoint.inbound[0].id, null)
}

output "outbound_endpoint_id" {
  value = try(aws_route53_resolver_endpoint.outbound[0].id, null)
}

output "forwarding_rule_ids" {
  value = { for k, r in aws_route53_resolver_rule.forward : k => r.id }
}
