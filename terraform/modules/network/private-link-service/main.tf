# PrivateLink — provider (endpoint service) and/or consumer (interface endpoint).

resource "aws_vpc_endpoint_service" "provider" {
  count = var.create_endpoint_service ? 1 : 0

  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = var.nlb_arns
  allowed_principals         = var.allowed_principals
  private_dns_name           = var.private_dns_name
  supported_ip_address_types = var.supported_ip_address_types
  tags                       = merge(var.tags, { Name = "${var.name}-eps" })
}

resource "aws_vpc_endpoint" "consumer" {
  count = var.create_consumer_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = coalesce(var.service_name, try(aws_vpc_endpoint_service.provider[0].service_name, null))
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled
  tags                = merge(var.tags, { Name = "${var.name}-vpce" })
}
