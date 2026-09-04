output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "database_subnet_ids" {
  value = [for s in aws_subnet.database : s.id]
}

output "public_subnet_ids_map" {
  value = { for k, s in aws_subnet.public : k => s.id }
}

output "private_subnet_ids_map" {
  value = { for k, s in aws_subnet.private : k => s.id }
}
