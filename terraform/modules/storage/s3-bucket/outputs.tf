output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "versioning_status" {
  value = var.versioning_enabled ? "Enabled" : "Suspended"
}

output "access_point_arns" {
  value = { for k, ap in aws_s3_access_point.this : k => ap.arn }
}

output "access_point_ids" {
  value = { for k, ap in aws_s3_access_point.this : k => ap.id }
}
