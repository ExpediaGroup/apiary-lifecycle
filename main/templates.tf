/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "template_file" "beekeeper_path_scheduler_container_definition" {
  count    = "${var.instance_type == "ecs" ? 1 : 0}"
  template = "${file("${path.module}/files/container-definition.json")}"

  vars = {
    db_password_strategy  = "${var.db_password_strategy}"
    db_password_key       = "${var.db_password_key}"
    docker_image          = "${var.path_scheduler_docker_image}"
    docker_image_version  = "${var.path_scheduler_docker_image_version}"
    beekeeper_config_yaml = "${base64encode(data.template_file.beekeeper_path_scheduler_config.rendered)}"
    log_group             = "${aws_cloudwatch_log_group.beekeeper_path_scheduler.*.name[0]}"
    memory                = "${var.path_scheduler_ecs_memory}"
    name                  = "${local.instance_alias}-path-scheduler"
    port                  = 8080
    region                = "${var.aws_region}"

    #to instruct ECS to use repositoryCredentials for private docker registry
    docker_auth = "${var.docker_registry_auth_secret_name == "" ? "" : format("\"repositoryCredentials\" :{\n \"credentialsParameter\":\"%s\"\n},", join("", data.aws_secretsmanager_secret.docker_registry.*.arn))}"
  }
}

data "template_file" "beekeeper_path_scheduler_config" {
  template = "${file("${path.module}/files/beekeeper-path-scheduler-config.yml")}"

  vars = {
    db_endpoint      = "${aws_db_instance.beekeeper.endpoint}"
    db_username      = "${aws_db_instance.beekeeper.username}"
    queue            = "${aws_sqs_queue.beekeeper.id}"
    graphite_enabled = "${var.graphite_enabled}"
    graphite_host    = "${var.graphite_host}"
    graphite_prefix  = "${var.graphite_prefix}"
    graphite_port    = "${var.graphite_port}"
  }
}


data "template_file" "beekeeper_cleanup_container_definition" {
  count    = "${var.instance_type == "ecs" ? 1 : 0}"
  template = "${file("${path.module}/files/container-definition.json")}"

  vars = {
    db_password_strategy  = "${var.db_password_strategy}"
    db_password_key       = "${var.db_password_key}"
    docker_image          = "${var.cleanup_docker_image}"
    docker_image_version  = "${var.cleanup_docker_image_version}"
    beekeeper_config_yaml = "${base64encode(data.template_file.beekeeper_cleanup_config.rendered)}"
    log_group             = "${aws_cloudwatch_log_group.beekeeper_cleanup.*.name[0]}"
    memory                = "${var.cleanup_ecs_memory}"
    name                  = "${local.instance_alias}-cleanup"
    port                  = 8008
    region                = "${var.aws_region}"

    #to instruct ECS to use repositoryCredentials for private docker registry
    docker_auth = "${var.docker_registry_auth_secret_name == "" ? "" : format("\"repositoryCredentials\" :{\n \"credentialsParameter\":\"%s\"\n},", join("", data.aws_secretsmanager_secret.docker_registry.*.arn))}"
  }
}

data "template_file" "beekeeper_cleanup_config" {
  template = "${file("${path.module}/files/beekeeper-cleanup-config.yml")}"

  vars = {
    db_endpoint        = "${aws_db_instance.beekeeper.endpoint}"
    db_username        = "${aws_db_instance.beekeeper.username}"
    graphite_enabled   = "${var.graphite_enabled}"
    graphite_host      = "${var.graphite_host}"
    graphite_prefix    = "${var.graphite_prefix}"
    graphite_port      = "${var.graphite_port}"
    scheduler_delay_ms = "${var.scheduler_delay_ms}"
    dry_run_enabled    = "${var.dry_run_enabled}"
  }
}
