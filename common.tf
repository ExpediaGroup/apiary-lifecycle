/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "aws_region" "current" {}

locals {
  instance_alias = var.instance_name == "" ? "beekeeper" : format("beekeeper-%s", var.instance_name)
  queue_alias    = var.instance_name == "" ? var.queue_name : "${var.queue_name}-${var.instance_name}"
  k8s_app_alias  = var.k8s_app_name == "" ? "beekeeper" : format("beekeeper-%s", var.k8s_app_name)
  dnsdomain      = "${data.aws_iam_account_alias.current.account_alias}.aws.away.black"
  dnsname        = "egdl-eks-${data.aws_region.current.name}"

  aws_region_key              = "AWS_REGION"
  aws_default_region_key      = "AWS_DEFAULT_REGION"
  db_password_key             = "SPRING_DATASOURCE_PASSWORD"
  spring_application_json_key = "SPRING_APPLICATION_JSON"
}

data "aws_iam_account_alias" "current" {}

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
