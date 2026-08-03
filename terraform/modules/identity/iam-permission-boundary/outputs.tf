output "permissions_boundary_arn" {
  value = aws_iam_policy.boundary.arn
}

output "permissions_boundary_name" {
  value = aws_iam_policy.boundary.name
}
