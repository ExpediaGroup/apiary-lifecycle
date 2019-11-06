/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_policy" "beekeeper_ecs_task_exec_docker_registry" {
  count = "${var.docker_registry_auth_secret_name != "" ? 1 : 0}"
  name  = "${local.instance_alias}-ecs-task-exec-docker-registry"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": [ "${join("\",\"", concat(data.aws_secretsmanager_secret.docker_registry.*.arn))}" ]
      }
    ]
}
EOF
}

resource "aws_iam_policy" "beekeeper_secrets" {
  name = "${local.instance_alias}-secrets-${var.aws_region}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": [ "${data.aws_secretsmanager_secret.beekeeper_db.arn}" ]
      }
    ]
}
EOF
}
