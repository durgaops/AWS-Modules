output "graph_arn" {
  value = aws_detective_graph.this.graph_arn
}
output "graph_id" {
  value = aws_detective_graph.this.id
}
output "member_ids" {
  value = { for k, m in aws_detective_member.this : k => m.id }
}
