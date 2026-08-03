# Controlled Client VPN endpoint.

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = var.description
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  transport_protocol     = var.transport_protocol
  vpn_port               = var.vpn_port
  dns_servers            = var.dns_servers
  security_group_ids     = var.security_group_ids
  vpc_id                 = var.vpc_id
  self_service_portal    = var.self_service_portal
  session_timeout_hours  = var.session_timeout_hours

  authentication_options {
    type                       = var.authentication_type
    root_certificate_chain_arn = var.authentication_type == "certificate-authentication" ? var.root_certificate_chain_arn : null
    saml_provider_arn          = contains(["federated-authentication"], var.authentication_type) ? var.saml_provider_arn : null
    active_directory_id        = var.authentication_type == "directory-service-authentication" ? var.active_directory_id : null
  }

  connection_log_options {
    enabled               = var.connection_logging
    cloudwatch_log_group  = var.cloudwatch_log_group
    cloudwatch_log_stream = var.cloudwatch_log_stream
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_ec2_client_vpn_network_association" "this" {
  for_each = toset(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  for_each = { for idx, r in var.authorization_rules : try(r.name, "auth-${idx}") => r }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = each.value.target_network_cidr
  access_group_id        = try(each.value.access_group_id, null)
  authorize_all_groups   = try(each.value.authorize_all_groups, true)
  description            = try(each.value.description, each.key)
}
