output "route_table_ids" {
  description = "Map of route table IDs keyed by input map keys"
  value       = { for k, rt in aws_route_table.this : k => rt.id }
}

output "route_table_arns" {
  description = "Map of route table ARNs keyed by input map keys"
  value       = { for k, rt in aws_route_table.this : k => rt.arn }
}

output "association_ids" {
  description = "Map of route table association IDs"
  value       = { for k, a in aws_route_table_association.this : k => a.id }
}
