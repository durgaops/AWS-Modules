# Secure EC2 launch templates (IMDSv2, encrypted EBS, tagging).

resource "aws_launch_template" "this" {
  name_prefix   = var.name_prefix != null ? var.name_prefix : null
  name          = var.name_prefix == null ? var.name : null
  description   = var.description
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data_base64 != null ? var.user_data_base64 : (var.user_data != null ? base64encode(var.user_data) : null)
  ebs_optimized = var.ebs_optimized
  update_default_version = var.update_default_version

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_name != null || var.iam_instance_profile_arn != null ? [1] : []
    content {
      name = var.iam_instance_profile_name
      arn  = var.iam_instance_profile_arn
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = try(block_device_mappings.value.volume_type, "gp3")
        encrypted             = try(block_device_mappings.value.encrypted, true)
        kms_key_id            = try(block_device_mappings.value.kms_key_id, var.kms_key_id)
        delete_on_termination = try(block_device_mappings.value.delete_on_termination, true)
        iops                  = try(block_device_mappings.value.iops, null)
        throughput            = try(block_device_mappings.value.throughput, null)
      }
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.imds_http_tokens
    http_put_response_hop_limit = var.imds_hop_limit
    instance_metadata_tags      = var.instance_metadata_tags
  }

  monitoring {
    enabled = var.detailed_monitoring
  }

  dynamic "network_interfaces" {
    for_each = length(var.security_group_ids) > 0 || var.associate_public_ip != null ? [1] : []
    content {
      associate_public_ip_address = var.associate_public_ip
      security_groups             = var.security_group_ids
      delete_on_termination       = true
    }
  }

  dynamic "placement" {
    for_each = var.placement_group != null || var.tenancy != null || var.availability_zone != null ? [1] : []
    content {
      availability_zone = var.availability_zone
      group_name        = var.placement_group
      tenancy           = var.tenancy
    }
  }

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price                      = var.spot_max_price
        spot_instance_type             = var.spot_instance_type
        instance_interruption_behavior = var.spot_interruption_behavior
      }
    }
  }

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume", "network-interface"])
    content {
      resource_type = tag_specifications.value
      tags          = merge(var.tags, { Name = var.name })
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "compute/ec2-launch-template"
  })
}
