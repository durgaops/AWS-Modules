package terraform.security

# Deny Security Groups with 0.0.0.0/0 on ingress for sensitive ports
deny[msg] {
  input.resource_changes[_].type == "aws_security_group"
  some i
  rule := input.resource_changes[_].change.after.ingress[i]
  rule.cidr_blocks[_] == "0.0.0.0/0"
  sensitive_ports := {22, 3389, 3306, 5432}
  sensitive_ports[rule.from_port]
  msg := sprintf("Security group opens sensitive port %v to the world", [rule.from_port])
}

# Require KMS CMK for CloudTrail when present in plan
deny[msg] {
  rc := input.resource_changes[_]
  rc.type == "aws_cloudtrail"
  rc.change.after.kms_key_id == null
  msg := "CloudTrail must use a customer-managed KMS key"
}
