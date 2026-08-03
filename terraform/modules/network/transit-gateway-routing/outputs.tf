output "route_table_ids" {
  value = { for k, rt in aws_ec2_transit_gateway_route_table.this : k => rt.id }
}
