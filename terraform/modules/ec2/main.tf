# Compatibility shim — prefer modules/compute/ec2-instance

module "this" {
  source = "../compute/ec2-instance"

  name                   = var.name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name
  user_data              = var.user_data
  root_volume_size       = var.root_volume_size
  root_volume_type       = var.root_volume_type
  kms_key_id             = var.kms_key_id
  associate_public_ip    = var.associate_public_ip
  tags                   = var.tags
}
