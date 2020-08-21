/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "template_file" "beekeeper_scheduler_container_definition" {
  count    = var.instance_type == "ecs" ? 1 : 0
  template = file("${path.module}/files/ecs-container-definition.json")

  vars = {
    db_password_strategy  = var.db_password_strategy
    db_password_key       = var.db_password_key
    docker_image          = var.scheduler_docker_image
    docker_image_version  = var.scheduler_docker_image_version
    beekeeper_config_yaml = base64encode(data.template_file.beekeeper_scheduler_config.rendered)
    log_group             = aws_cloudwatch_log_group.beekeeper_scheduler.*.name[0]
    memory                = var.scheduler_ecs_memory
    name                  = "${local.instance_alias}-scheduler"
    port                  = 8080
    region                = var.aws_region

    #to instruct ECS to use repositoryCredentials for private docker registry
    docker_auth = var.docker_registry_auth_secret_name == "" ? "" : format("\"repositoryCredentials\" :{\n \"credentialsParameter\":\"%s\"\n},", join("", data.aws_secretsmanager_secret.docker_registry.*.arn))
  }
}

data "template_file" "beekeeper_path_cleanup_container_definition" {
  count    = var.instance_type == "ecs" ? 1 : 0
  template = file("${path.module}/files/ecs-container-definition.json")

  vars = {
    db_password_strategy  = var.db_password_strategy
    db_password_key       = var.db_password_key
    docker_image          = var.path_cleanup_docker_image
    docker_image_version  = var.path_cleanup_docker_image_version
    beekeeper_config_yaml = base64encode(data.template_file.beekeeper_path_cleanup_config.rendered)
    log_group             = aws_cloudwatch_log_group.beekeeper_path_cleanup.*.name[0]
    memory                = var.path_cleanup_ecs_memory
    name                  = "${local.instance_alias}-path-cleanup"
    port                  = 8008
    region                = var.aws_region

    #to instruct ECS to use repositoryCredentials for private docker registry
    docker_auth = var.docker_registry_auth_secret_name == "" ? "" : format("\"repositoryCredentials\" :{\n \"credentialsParameter\":\"%s\"\n},", join("", data.aws_secretsmanager_secret.docker_registry.*.arn))
  }
}
