output "domain_arn" {
  value = aws_opensearch_domain.this.arn
}
output "domain_id" {
  value = aws_opensearch_domain.this.domain_id
}
output "domain_endpoint" {
  value = aws_opensearch_domain.this.endpoint
}
output "dashboard_endpoint" {
  value = aws_opensearch_domain.this.dashboard_endpoint
}
