# AWS Cloud WAN core network (adopt when enterprise WAN standardizes on Cloud WAN).

resource "aws_networkmanager_global_network" "this" {
  count       = var.create_global_network ? 1 : 0
  description = var.global_network_description
  tags        = merge(var.tags, { Name = var.name })
}

resource "aws_networkmanager_core_network" "this" {
  global_network_id = var.create_global_network ? aws_networkmanager_global_network.this[0].id : var.global_network_id
  description       = var.core_network_description
  tags              = merge(var.tags, { Name = "${var.name}-core" })
}

resource "aws_networkmanager_core_network_policy_attachment" "this" {
  count           = var.policy_document != null ? 1 : 0
  core_network_id = aws_networkmanager_core_network.this.id
  policy_document = var.policy_document
}
