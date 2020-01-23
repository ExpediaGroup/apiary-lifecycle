/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
resource "aws_iam_role" "beekeeper_path_scheduler_ecs_task" {
  count = var.instance_type == "ecs" ? 1 : 0
  name  = "${local.instance_alias}-path-scheduler-ecs-task-${var.aws_region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_path_scheduler_secrets" {
  count      = var.instance_type == "ecs" ? 1 : 0
  role       = aws_iam_role.beekeeper_path_scheduler_ecs_task.*.id[0]
  policy_arn = aws_iam_policy.beekeeper_secrets.arn
}

resource "aws_iam_role_policy_attachment" "beekeeper_path_scheduler_sqs" {
  count      = var.instance_type == "ecs" ? 1 : 0
  role       = aws_iam_role.beekeeper_path_scheduler_ecs_task.*.id[0]
  policy_arn = aws_iam_policy.beekeeper_sqs.arn
}
