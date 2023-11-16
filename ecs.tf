/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_ecs_cluster" "beekeeper" {
  count = var.instance_type == "ecs" ? 1 : 0
  name  = local.instance_alias
  tags  = var.beekeeper_tags
}

resource "aws_ecs_service" "beekeeper_scheduler_apiary" {
  count           = var.instance_type == "ecs" ? 1 : 0
  name            = "${local.instance_alias}-scheduler-apiary"
  cluster         = aws_ecs_cluster.beekeeper.*.id[0]
  task_definition = aws_ecs_task_definition.beekeeper_scheduler_apiary.*.arn[0]
  desired_count   = 1
  launch_type     = "FARGATE"
  propagate_tags  = "SERVICE"
  tags            = var.beekeeper_tags

  network_configuration {
    security_groups = [aws_security_group.beekeeper_sg.id]
    subnets         = var.subnets
  }
}

resource "aws_ecs_service" "beekeeper_path_cleanup" {
  count           = var.instance_type == "ecs" ? 1 : 0
  name            = "${local.instance_alias}-path-cleanup"
  cluster         = aws_ecs_cluster.beekeeper.*.id[0]
  task_definition = aws_ecs_task_definition.beekeeper_path_cleanup.*.arn[0]
  desired_count   = 1
  launch_type     = "FARGATE"
  propagate_tags  = "SERVICE"
  tags            = var.beekeeper_tags

  network_configuration {
    security_groups = [aws_security_group.beekeeper_sg.id]
    subnets         = var.subnets
  }
}

resource "aws_ecs_task_definition" "beekeeper_scheduler_apiary" {
  count                    = var.instance_type == "ecs" ? 1 : 0
  family                   = local.instance_alias
  execution_role_arn       = aws_iam_role.beekeeper_ecs_task_exec.*.arn[0]
  task_role_arn            = aws_iam_role.beekeeper_scheduler_apiary_ecs_task.*.arn[0]
  container_definitions    = data.template_file.beekeeper_scheduler_apiary_container_definition.*.rendered[0]
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = var.scheduler_apiary_ecs_cpu
  memory                   = var.scheduler_apiary_ecs_memory
  tags                     = var.beekeeper_tags
}

resource "aws_ecs_task_definition" "beekeeper_path_cleanup" {
  count                    = var.instance_type == "ecs" ? 1 : 0
  family                   = local.instance_alias
  execution_role_arn       = aws_iam_role.beekeeper_ecs_task_exec.*.arn[0]
  task_role_arn            = aws_iam_role.beekeeper_path_cleanup_ecs_task.*.arn[0]
  container_definitions    = data.template_file.beekeeper_path_cleanup_container_definition.*.rendered[0]
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = var.path_cleanup_ecs_cpu
  memory                   = var.path_cleanup_ecs_memory
  tags                     = var.beekeeper_tags
}

resource "aws_cloudwatch_log_group" "beekeeper_scheduler_apiary" {
  count = var.instance_type == "ecs" ? 1 : 0
  name  = "${local.instance_alias}-scheduler-apiary"
  tags  = var.beekeeper_tags
}

resource "aws_cloudwatch_log_group" "beekeeper_path_cleanup" {
  count = var.instance_type == "ecs" ? 1 : 0
  name  = "${local.instance_alias}-path-cleanup"
  tags  = var.beekeeper_tags
}
