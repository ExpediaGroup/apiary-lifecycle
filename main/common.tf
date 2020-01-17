/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  instance_alias = var.instance_name == "" ? "beekeeper" : format("beekeeper-%s",var.instance_name)
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_secretsmanager_secret" "beekeeper_db" {
  name = var.db_password_key
}

data "aws_secretsmanager_secret_version" "beekeeper_db" {
  secret_id = data.aws_secretsmanager_secret.beekeeper_db.id
}   

data "aws_secretsmanager_secret" "docker_registry" {
  count = var.docker_registry_auth_secret_name == "" ? 0 : 1
  name  = var.docker_registry_auth_secret_name
}
