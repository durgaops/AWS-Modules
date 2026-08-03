locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/fsx-lustre"
    Name      = var.name
  })
}

resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity            = var.storage_capacity
  subnet_ids                  = var.subnet_ids
  security_group_ids          = var.security_group_ids
  deployment_type             = var.deployment_type
  per_unit_storage_throughput = var.per_unit_storage_throughput
  kms_key_id                  = var.kms_key_id
  import_path                 = var.import_path
  export_path                 = var.export_path
  tags                        = local.tags
}
