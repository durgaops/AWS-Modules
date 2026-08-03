output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "ipv6_cidr_block" {
  value = aws_vpc.this.ipv6_cidr_block
}

output "default_route_table_id" {
  value = aws_vpc.this.default_route_table_id
}

output "default_network_acl_id" {
  value = aws_vpc.this.default_network_acl_id
}

output "default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}
