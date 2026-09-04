output "trail_arn" {
  value = aws_cloudtrail.this.arn
}

output "trail_name" {
  value = aws_cloudtrail.this.name
}

output "home_region" {
  value = aws_cloudtrail.this.home_region
}
