/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_role" "beekeeper_k8s_role_api_iam" {
  count = var.instance_type == "k8s" ? 1 : 0
  name  = "${local.instance_alias}-api-${var.aws_region}"

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

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_api_s3" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_api_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_s3.arn
}

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_api_secrets" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_api_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_secrets.arn
}
