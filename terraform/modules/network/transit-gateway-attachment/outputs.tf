output "attachment_id" {
  value = coalesce(
    try(aws_ec2_transit_gateway_vpc_attachment.this[0].id, null),
    try(aws_ec2_transit_gateway_peering_attachment.this[0].id, null)
  )
}

output "vpc_attachment_id" {
  value = try(aws_ec2_transit_gateway_vpc_attachment.this[0].id, null)
}

output "peering_attachment_id" {
  value = try(aws_ec2_transit_gateway_peering_attachment.this[0].id, null)
}
