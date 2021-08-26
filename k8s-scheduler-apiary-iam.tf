/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_role" "beekeeper_k8s_role_scheduler_apiary_iam" {
  count = var.instance_type == "k8s" ? 1 : 0
  name  = "${local.instance_alias}-scheduler-apiary-${var.aws_region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.k8s_kiam_role_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_scheduler_apiary_sqs" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_scheduler_apiary_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_sqs.arn
}

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_scheduler_apiary_secrets" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_scheduler_apiary_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_secrets.arn
}
