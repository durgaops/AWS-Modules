output "route_table_ids" {
  value = { for k, rt in aws_route_table.this : k => rt.id }
}
