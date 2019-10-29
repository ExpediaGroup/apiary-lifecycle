/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "template_file" "beekeeper_s3_allowed_buckets" {
  template = <<JSON
$${val}
JSON

  vars {
    val = "${jsonencode(
              distinct(
                    compact(
                        split(",",
                                contains(var.allowed_s3_buckets, "*") || length(compact(var.allowed_s3_buckets)) == 0
                                ? "*"
                                : join(",", concat(
                                    formatlist("%s%s", "arn:aws:s3:::", var.allowed_s3_buckets),
                                    formatlist("%s%s/*", "arn:aws:s3:::", var.allowed_s3_buckets)
                                  ))
                            ))))}"
  }
}

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
      "Resource": "${data.template_file.beekeeper_s3_allowed_buckets.rendered}"
    }
  ]
}
EOF
