# Gateway and Interface VPC endpoints.

resource "aws_vpc_endpoint" "gateway" {
  for_each = var.gateway_endpoints

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = try(each.value.route_table_ids, [])
  policy            = try(each.value.policy, null)
  tags              = merge(var.tags, { Name = each.key })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.interface_endpoints

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = try(each.value.subnet_ids, [])
  security_group_ids  = try(each.value.security_group_ids, [])
  private_dns_enabled = try(each.value.private_dns_enabled, true)
  policy              = try(each.value.policy, null)
  tags                = merge(var.tags, { Name = each.key })
}
