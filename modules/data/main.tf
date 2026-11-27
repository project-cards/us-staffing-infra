# ----------------------------------------------------------------------------
# main.tf (module: data)
#
# The dev PostgreSQL database, in the private database subnets.
#   subnet group   -> tells RDS which private subnets it may use
#   security group -> the guard: port 5432, from the cluster's security group only
#   parameter group -> forces every connection to use SSL
#   the instance   -> encrypted with our KMS key, not public, password kept in Secrets Manager
# ----------------------------------------------------------------------------

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db"
  description = "PostgreSQL 5432, allowed only from the EKS cluster security group"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "from_cluster" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = var.cluster_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL from the EKS nodes and pods only"
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-postgres16"
  family = "postgres16"

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier        = "${var.name}-postgres"
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  db_name  = var.db_name
  username = var.master_username

  # RDS creates the password and stores it in Secrets Manager (encrypted with our key).
  # It never appears in code or in Terraform state as plain text.
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.kms_key_arn

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = false

  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention_days
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name}-postgres-final"
  auto_minor_version_upgrade = true

  tags = var.tags

  lifecycle {
    # Minor version upgrades are applied by AWS, so do not show them as drift.
    ignore_changes = [engine_version]
  }
}
