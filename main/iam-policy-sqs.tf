/**
 * Copyright (C) 2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_role_policy" "beekeeper_path_scheduler_ecs_task_sqs" {
  name = "${local.instance_alias}-path-scheduler-ecs-task-sqs-${var.aws_region}"
  role = "${aws_iam_role.beekeeper_path_scheduler_ecs_task.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        "Resource": "${aws_sqs_queue.beekeeper.arn}"
      }
    ]
}
EOF
}
