output "permission_set_arn" {
  value = aws_ssoadmin_permission_set.this.arn
}

output "permission_set_name" {
  value = aws_ssoadmin_permission_set.this.name
}

output "instance_arn" {
  value = local.instance_arn
}
