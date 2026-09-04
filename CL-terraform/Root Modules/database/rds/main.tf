# RDS instance with DB subnet group. Storage encryption is required.

resource "aws_db_subnet_group" "this" {
  name       = coalesce(var.db_subnet_group_name, "${var.identifier}-subnet-group")
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name   = coalesce(var.db_subnet_group_name, "${var.identifier}-subnet-group")
    Module = "database/rds"
  })
}

resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : coalesce(var.final_snapshot_identifier, "${var.identifier}-final")
  apply_immediately         = var.apply_immediately

  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  tags = merge(var.tags, {
    Name   = var.identifier
    Module = "database/rds"
  })
}
