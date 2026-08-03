# Standard managed EC2 workload.

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change
  associate_public_ip_address = var.associate_public_ip
  private_ip                  = var.private_ip
  monitoring                  = var.detailed_monitoring
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  availability_zone           = var.availability_zone
  placement_group             = var.placement_group
  tenancy                     = var.tenancy
  hibernation                 = var.hibernation

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.imds_http_tokens
    http_put_response_hop_limit = var.imds_hop_limit
    instance_metadata_tags      = var.instance_metadata_tags
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = var.root_delete_on_termination
    iops                  = var.root_iops
    throughput            = var.root_throughput
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = try(ebs_block_device.value.volume_type, "gp3")
      encrypted             = try(ebs_block_device.value.encrypted, true)
      kms_key_id            = try(ebs_block_device.value.kms_key_id, var.kms_key_id)
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, true)
      iops                  = try(ebs_block_device.value.iops, null)
      throughput            = try(ebs_block_device.value.throughput, null)
    }
  }

  dynamic "credit_specification" {
    for_each = var.cpu_credits != null ? [1] : []
    content {
      cpu_credits = var.cpu_credits
    }
  }

  tags = merge(var.tags, { Name = var.name, Module = "compute/ec2-instance" })
  volume_tags = merge(var.tags, var.volume_tags, { Name = var.name })
}
