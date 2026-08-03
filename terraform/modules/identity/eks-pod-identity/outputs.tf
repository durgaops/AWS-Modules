output "role_arn" {
  value = module.role.role_arn
}

output "role_name" {
  value = module.role.role_name
}

output "pod_identity_association_ids" {
  value = { for k, a in aws_eks_pod_identity_association.this : k => a.association_id }
}
