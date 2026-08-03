output "primary_key_id" {
  value = aws_kms_key.primary.key_id
}
output "primary_key_arn" {
  value = aws_kms_key.primary.arn
}
output "primary_alias_name" {
  value = aws_kms_alias.primary.name
}
output "replica_key_id" {
  value = try(aws_kms_replica_key.replica[0].key_id, null)
}
output "replica_key_arn" {
  value = try(aws_kms_replica_key.replica[0].arn, null)
}
