output "subnet_ids" {
  description = "Map of key => subnet id"
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "subnet_arns" {
  value = { for k, s in aws_subnet.this : k => s.arn }
}

output "public_subnet_ids" {
  value = [for k, s in aws_subnet.this : s.id if s.tags["Tier"] == "public"]
}

output "private_subnet_ids" {
  value = [for k, s in aws_subnet.this : s.id if s.tags["Tier"] == "private"]
}

output "application_subnet_ids" {
  value = [for k, s in aws_subnet.this : s.id if s.tags["Tier"] == "application"]
}

output "database_subnet_ids" {
  value = [for k, s in aws_subnet.this : s.id if s.tags["Tier"] == "database"]
}

output "inspection_subnet_ids" {
  value = [for k, s in aws_subnet.this : s.id if s.tags["Tier"] == "inspection"]
}
