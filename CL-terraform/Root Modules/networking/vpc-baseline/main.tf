# TCH VPC Baseline — private network foundation.
# Same module for Non-Prod and Prod. Environment values are passed in.

data "aws_region" "current" {}

locals {
  tiers = ["workload", "endpoint", "nlb", "tgw"]

  subnets = merge([
    for az, cfg in var.az_subnets : {
      "${az}-workload" = { az = az, tier = "workload", cidr = cfg.workload_cidr }
      "${az}-endpoint" = { az = az, tier = "endpoint", cidr = cfg.endpoint_cidr }
      "${az}-nlb"      = { az = az, tier = "nlb", cidr = cfg.nlb_cidr }
      "${az}-tgw"      = { az = az, tier = "tgw", cidr = cfg.tgw_cidr }
    }
  ]...)

  routes = merge([
    for tier, tier_routes in var.routes : {
      for idx, route in tier_routes : "${tier}-${idx}" => merge(route, { tier = tier })
    }
  ]...)

  flow_log_name = coalesce(var.flow_log_name, "${var.name}-flow-logs")

  endpoint_subnet_ids = [for key, subnet in aws_subnet.this : subnet.id if endswith(key, "-endpoint")]

  interface_endpoints = {
    for name, ep in var.interface_endpoints : name => {
      service_name        = ep.service_name != "" ? ep.service_name : "com.amazonaws.${data.aws_region.current.name}.${ep.service}"
      private_dns_enabled = coalesce(ep.private_dns_enabled, var.private_dns_enabled)
    }
  }

  gateway_endpoints = {
    for name, ep in var.gateway_endpoints : name => {
      service_name = ep.service_name != "" ? ep.service_name : "com.amazonaws.${data.aws_region.current.name}.${ep.service}"
      route_table_ids = [
        for tier, rt in aws_route_table.this : rt.id
        if ep.route_table_tiers == null || contains(ep.route_table_tiers, tier)
      ]
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy

  tags = merge(var.tags, { Name = var.name, Module = "networking/vpc-baseline" })
}

resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name   = "${var.name}-${each.value.tier}-${each.value.az}"
    Tier   = each.value.tier
    Module = "networking/vpc-baseline"
  })
}

resource "aws_route_table" "this" {
  for_each = toset(local.tiers)

  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name   = coalesce(try(var.route_table_config[each.key].name, null), "${var.name}-${each.key}")
    Tier   = each.key
    Module = "networking/vpc-baseline"
  })
}

resource "aws_route" "this" {
  for_each = local.routes

  route_table_id              = aws_route_table.this[each.value.tier].id
  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  transit_gateway_id          = each.value.transit_gateway_id
  nat_gateway_id              = each.value.nat_gateway_id
  gateway_id                  = each.value.gateway_id
  vpc_endpoint_id             = each.value.vpc_endpoint_id
  network_interface_id        = each.value.network_interface_id
}

resource "aws_route_table_association" "this" {
  for_each = aws_subnet.this

  subnet_id      = each.value.id
  route_table_id = aws_route_table.this[trimprefix(each.key, "${local.subnets[each.key].az}-")].id
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name   = "${var.name}-default"
    Module = "networking/vpc-baseline"
  })
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  subnet_ids             = [for subnet in aws_subnet.this : subnet.id]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    rule_no    = 120
    protocol   = "udp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.tags, {
    Name   = "${var.name}-default"
    Module = "networking/vpc-baseline"
  })
}

resource "aws_cloudwatch_log_group" "flow" {
  name              = "/aws/vpc/${local.flow_log_name}"
  retention_in_days = var.flow_log_retention_days
  tags              = merge(var.tags, { Name = local.flow_log_name, Module = "networking/vpc-baseline" })
}

data "aws_iam_policy_document" "flow_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["${aws_cloudwatch_log_group.flow.arn}:*"]
  }
}

resource "aws_iam_role" "flow" {
  name               = "${local.flow_log_name}-role"
  assume_role_policy = data.aws_iam_policy_document.flow_assume.json
  tags               = merge(var.tags, { Name = "${local.flow_log_name}-role", Module = "networking/vpc-baseline" })
}

resource "aws_iam_role_policy" "flow" {
  name   = "${local.flow_log_name}-publish"
  role   = aws_iam_role.flow.id
  policy = data.aws_iam_policy_document.flow.json
}

resource "aws_flow_log" "this" {
  vpc_id                   = aws_vpc.this.id
  traffic_type             = var.flow_log_traffic_type
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flow.arn
  iam_role_arn             = aws_iam_role.flow.arn
  max_aggregation_interval = 60

  tags = merge(var.tags, { Name = local.flow_log_name, Module = "networking/vpc-baseline" })
}

resource "aws_security_group" "endpoints" {
  count = length(var.interface_endpoints) > 0 ? 1 : 0

  name        = "${var.name}-endpoints"
  description = "HTTPS access to interface VPC endpoints"
  vpc_id      = aws_vpc.this.id
  tags        = merge(var.tags, var.endpoint_tags, { Name = "${var.name}-endpoints", Module = "networking/vpc-baseline" })

  lifecycle {
    precondition {
      condition     = length(var.endpoint_ingress_cidrs) > 0
      error_message = "endpoint_ingress_cidrs is required when interface_endpoints are set."
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "endpoints" {
  for_each = length(var.interface_endpoints) > 0 ? toset(var.endpoint_ingress_cidrs) : []

  security_group_id = aws_security_group.endpoints[0].id
  description       = "HTTPS from approved CIDR"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_egress_rule" "endpoints" {
  count = length(var.interface_endpoints) > 0 ? 1 : 0

  security_group_id = aws_security_group.endpoints[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = var.vpc_cidr
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints

  vpc_id              = aws_vpc.this.id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.endpoints[0].id]
  private_dns_enabled = each.value.private_dns_enabled

  tags = merge(var.tags, var.endpoint_tags, { Name = "${var.name}-${each.key}", Module = "networking/vpc-baseline" })
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = local.gateway_endpoints

  vpc_id            = aws_vpc.this.id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = each.value.route_table_ids

  tags = merge(var.tags, var.endpoint_tags, { Name = "${var.name}-${each.key}", Module = "networking/vpc-baseline" })
}
