resource "aws_globalaccelerator_accelerator" "this" {
  name            = var.name
  ip_address_type = var.ip_address_type
  enabled         = var.enabled
  tags            = merge(var.tags, { Name = var.name })
}

resource "aws_globalaccelerator_listener" "this" {
  for_each = { for idx, l in var.listeners : try(l.name, "listener-${idx}") => l }

  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  client_affinity = try(each.value.client_affinity, "NONE")
  protocol        = each.value.protocol

  dynamic "port_range" {
    for_each = each.value.port_ranges
    content {
      from_port = port_range.value.from_port
      to_port   = port_range.value.to_port
    }
  }
}

resource "aws_globalaccelerator_endpoint_group" "this" {
  for_each = { for idx, eg in var.endpoint_groups : try(eg.name, "eg-${idx}") => eg }

  listener_arn                  = aws_globalaccelerator_listener.this[each.value.listener_key].id
  endpoint_group_region         = each.value.region
  health_check_interval_seconds = try(each.value.health_check_interval_seconds, 30)
  health_check_path             = try(each.value.health_check_path, null)
  health_check_protocol         = try(each.value.health_check_protocol, "TCP")
  threshold_count               = try(each.value.threshold_count, 3)
  traffic_dial_percentage       = try(each.value.traffic_dial_percentage, 100)

  dynamic "endpoint_configuration" {
    for_each = try(each.value.endpoints, [])
    content {
      endpoint_id                    = endpoint_configuration.value.endpoint_id
      weight                         = try(endpoint_configuration.value.weight, 100)
      client_ip_preservation_enabled = try(endpoint_configuration.value.client_ip_preservation_enabled, true)
    }
  }
}
