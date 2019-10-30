/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_ecs_cluster" "beekeeper" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}"
  tags  = "${var.beekeeper_tags}"
}

resource "aws_ecs_service" "beekeeper_path_scheduler" {
  count           = "${var.instance_type == "ecs" ? 1 : 0}"
  name            = "${local.instance_alias}-path-scheduler"
  cluster         = "${aws_ecs_cluster.beekeeper.id}"
  task_definition = "${aws_ecs_task_definition.beekeeper_path_scheduler.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.beekeeper_sg.id}"]
    subnets         = "${var.subnets}"
  }
}

resource "aws_ecs_service" "beekeeper_cleanup" {
  count           = "${var.instance_type == "ecs" ? 1 : 0}"
  name            = "beekeeper_cleanup"
  cluster         = "${aws_ecs_cluster.beekeeper.id}"
  task_definition = "${aws_ecs_task_definition.beekeeper_cleanup.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.beekeeper_sg.id}"]
    subnets         = "${var.subnets}"
  }
}

resource "aws_ecs_task_definition" "beekeeper_path_scheduler" {
  count                    = "${var.instance_type == "ecs" ? 1 : 0}"
  family                   = "${local.instance_alias}"
  execution_role_arn       = "${aws_iam_role.beekeeper_ecs_task_exec.*.arn[0]}"
  task_role_arn            = "${aws_iam_role.beekeeper_path_scheduler_ecs_task.*.arn[0]}"
  container_definitions    = "${data.template_file.beekeeper_path_scheduler_container_definition.rendered}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = "${var.path_scheduler_ecs_cpu}"
  memory                   = "${var.path_scheduler_ecs_memory}"
  tags                     = "${var.beekeeper_tags}"
}

resource "aws_ecs_task_definition" "beekeeper_cleanup" {
  count                    = "${var.instance_type == "ecs" ? 1 : 0}"
  family                   = "${local.instance_alias}"
  execution_role_arn       = "${aws_iam_role.beekeeper_ecs_task_exec.*.arn[0]}"
  task_role_arn            = "${aws_iam_role.beekeeper_cleanup_ecs_task.*.arn[0]}"
  container_definitions    = "${data.template_file.beekeeper_cleanup_container_definition.rendered}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = "${var.cleanup_ecs_cpu}"
  memory                   = "${var.cleanup_ecs_memory}"
  tags                     = "${var.beekeeper_tags}"
}

resource "aws_cloudwatch_log_group" "beekeeper_path_scheduler" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-path-scheduler"
  tags  = "${var.beekeeper_tags}"
}

resource "aws_cloudwatch_log_group" "beekeeper_cleanup" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-cleanup"
  tags  = "${var.beekeeper_tags}"
}
