# Standard managed EC2 instance for any project workload.

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.detailed_monitoring
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.imds_http_tokens
    http_put_response_hop_limit = var.imds_hop_limit
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = var.root_delete_on_termination
  }

  tags = merge(var.tags, { Name = var.name, Module = "compute/ec2" })
  volume_tags = merge(var.tags, { Name = var.name })
}
