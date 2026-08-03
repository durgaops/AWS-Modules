output "file_system_id" { value = aws_efs_file_system.this.id }
output "file_system_arn" { value = aws_efs_file_system.this.arn }
output "dns_name" { value = aws_efs_file_system.this.dns_name }
output "mount_target_ids" { value = { for k, mt in aws_efs_mount_target.this : k => mt.id } }
