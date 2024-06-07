/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_iam_role" "beekeeper_k8s_role_metadata_cleanup_iam" {
  count = var.instance_type == "k8s" ? 1 : 0
  name  = "${local.instance_alias}-metadata-cleanup-${var.aws_region}"

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
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
       "Condition": {
         "StringEquals": {
           "${var.oidc_provider}:sub": "system:serviceaccount:${var.k8s_namespace}:${local.metadata_cleanup_full_name}"
         }
       }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_metadata_cleanup_s3" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_metadata_cleanup_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_s3.arn
}

resource "aws_iam_role_policy_attachment" "beekeeper_k8s_metadata_cleanup_secrets" {
  count      = var.instance_type == "k8s" ? 1 : 0
  role       = aws_iam_role.beekeeper_k8s_role_metadata_cleanup_iam[count.index].id
  policy_arn = aws_iam_policy.beekeeper_secrets.arn
}
