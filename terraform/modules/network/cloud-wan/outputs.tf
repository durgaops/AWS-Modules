output "global_network_id" {
  value = try(aws_networkmanager_global_network.this[0].id, var.global_network_id)
}

output "core_network_id" {
  value = aws_networkmanager_core_network.this.id
}

output "core_network_arn" {
  value = aws_networkmanager_core_network.this.arn
}
