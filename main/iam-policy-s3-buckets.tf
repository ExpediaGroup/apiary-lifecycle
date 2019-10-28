/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_policy" "beekeeper_s3" {
  name = "${local.instance_alias}-s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion"
      ],
      "Resource": [
                   "${join("\",\"", formatlist("arn:aws:s3:::%s",var.allowed_s3_buckets))}",
                   "${join("\",\"", formatlist("arn:aws:s3:::%s/*",var.allowed_s3_buckets))}"
                  ]
    }
  ]
}
EOF
}
