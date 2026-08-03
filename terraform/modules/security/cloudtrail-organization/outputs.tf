output "trail_arn" {
  value = aws_cloudtrail.this.arn
}
output "trail_home_region" {
  value = aws_cloudtrail.this.home_region
}
output "trail_name" {
  value = aws_cloudtrail.this.name
}
