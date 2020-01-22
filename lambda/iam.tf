/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */


resource "aws_iam_role" "beekeeper_slack_notifier_lambda" {
  name               = "${local.instance_alias}-slack-notifier-lambda-${var.aws_region}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "beekeeper_lambda_vpc_access" {
  name        = "${local.instance_alias}-lambda-vpc-access-${var.aws_region}"
  description = "VPC and CloudWatch access for Beekeeper Slack Notifier Lambda function"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_slack_notifier_lambda" {
  role       = aws_iam_role.beekeeper_slack_notifier_lambda.id
  policy_arn = aws_iam_policy.beekeeper_lambda_vpc_access.arn
}
