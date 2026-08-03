output "firewall_id" {
  value = aws_networkfirewall_firewall.this.id
}

output "firewall_arn" {
  value = aws_networkfirewall_firewall.this.arn
}

output "firewall_policy_arn" {
  value = try(aws_networkfirewall_firewall_policy.this[0].arn, var.firewall_policy_arn)
}

output "firewall_status" {
  value = aws_networkfirewall_firewall.this.firewall_status
}
