/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_lambda_function" "beekeeper_slack_notifier" {
  filename         = "slack-notifier.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  function_name    = "beekeeper-slack-notifier"
  role             = "${aws_iam_role.beekeeper_slack_notifier_lambda.arn}"
  handler          = "slack-notifier.lambda_handler"
  runtime          = "python3.7"
  timeout          = 20
  tags             = "${var.beekeeper_tags}"

  environment {
    variables = {
      slackChannel    = "${var.slack_channel}"
      slackWebhookUrl = "${var.slack_webhook_url}"
      account         = "${data.aws_iam_account_alias.current.account_alias}"
    }
  }

  vpc_config {
    subnet_ids         = "${var.subnets}"
    security_group_ids = "${var.security_groups}"
  }
}

resource "aws_lambda_permission" "beekeeper_slack_notifier" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.beekeeper_slack_notifier.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.beekeeper_sqs_dlq.arn}"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/slack-notifier.py"
  output_path = "${path.cwd}/slack-notifier.zip"
}
