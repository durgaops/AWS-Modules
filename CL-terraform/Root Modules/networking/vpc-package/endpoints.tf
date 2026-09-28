locals {
  endpoint_subnet_ids = length(aws_subnet.private) > 0 ? [for s in aws_subnet.private : s.id] : [for s in aws_subnet.public : s.id]

  gateway_route_table_ids = compact(concat(
    aws_route_table.public[*].id,
    aws_route_table.private[*].id,
    aws_route_table.database[*].id
  ))

  ssm_services = var.enable_ssm_endpoints ? {
    ssm         = "com.amazonaws.${data.aws_region.current.name}.ssm"
    ssmmessages = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
    ec2messages = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  } : {}
}

resource "aws_security_group" "endpoints" {
  count = length(local.ssm_services) > 0 || length(var.interface_endpoints) > 0 ? 1 : 0

  name        = "${var.name}-endpoints"
  description = "HTTPS to interface VPC endpoints"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-endpoints", Module = "networking/vpc-package" })
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_https" {
  count = length(aws_security_group.endpoints) > 0 ? 1 : 0

  security_group_id = aws_security_group.endpoints[0].id
  description       = "HTTPS from VPC"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = var.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "endpoints" {
  count = length(aws_security_group.endpoints) > 0 ? 1 : 0

  security_group_id = aws_security_group.endpoints[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint && length(local.gateway_route_table_ids) > 0 ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.gateway_route_table_ids

  tags = merge(var.tags, { Name = "${var.name}-s3", Module = "networking/vpc-package" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint && length(local.gateway_route_table_ids) > 0 ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.gateway_route_table_ids

  tags = merge(var.tags, { Name = "${var.name}-dynamodb", Module = "networking/vpc-package" })
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = length(local.endpoint_subnet_ids) > 0 ? local.ssm_services : {}

  vpc_id              = aws_vpc.this.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.endpoints[0].id]
  private_dns_enabled = true

  tags = merge(var.tags, { Name = "${var.name}-${each.key}", Module = "networking/vpc-package" })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = length(local.endpoint_subnet_ids) > 0 ? var.interface_endpoints : {}

  vpc_id              = aws_vpc.this.id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = coalesce(each.value.subnet_ids, local.endpoint_subnet_ids)
  security_group_ids  = coalesce(each.value.security_group_ids, try([aws_security_group.endpoints[0].id], []))
  private_dns_enabled = try(each.value.private_dns_enabled, true)

  tags = merge(var.tags, { Name = "${var.name}-${each.key}", Module = "networking/vpc-package" })
}
