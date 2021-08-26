/**
 * Copyright (C) 2019-2021Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_db_subnet_group" "beekeeper_db_subnet_group" {
  name        = "${local.instance_alias}-db-subnet-group"
  subnet_ids  = var.rds_subnets
  description = "Beekeeper DB Subnet Group for ${local.instance_alias}"

  tags = merge(var.beekeeper_tags,
  map("Name", "Beekeeper DB Subnet Group"))
}

resource "aws_security_group" "beekeeper_db_sg" {
  name   = "${local.instance_alias}-db"
  vpc_id = var.vpc_id
  tags   = var.beekeeper_tags

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    self        = true
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
}

resource "random_id" "snapshot_id" {
  byte_length = 8
}

resource "aws_db_instance" "beekeeper" {
  identifier             = local.instance_alias
  db_subnet_group_name   = aws_db_subnet_group.beekeeper_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.beekeeper_db_sg.id]
  allocated_storage      = var.rds_allocated_storage
  max_allocated_storage  = var.rds_max_allocated_storage
  storage_type           = var.rds_storage_type
  engine                 = "mysql"
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  // Don't use instance alias as part of default DB name since all the Flyway scripts expect "beekeeper" as the db name.
  // No reason to parameterize the db name anyway, since we have a different RDS instance per Beekeeper instance.
  name                      = "beekeeper"
  username                  = var.db_username
  password                  = chomp(data.aws_secretsmanager_secret_version.beekeeper_db.secret_string)
  parameter_group_name      = var.rds_parameter_group_name
  backup_retention_period   = var.db_backup_retention
  backup_window             = var.db_backup_window
  maintenance_window        = var.db_maintenance_window
  final_snapshot_identifier = "${local.instance_alias}-final-snapshot-${random_id.snapshot_id.hex}"
  tags                      = var.beekeeper_tags
}
