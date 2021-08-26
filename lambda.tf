/**
 * Copyright (C) 2019-2021Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_lambda_function" "beekeeper_slack_notifier" {
  count            = var.slack_lambda_enabled == 1 ? 1 : 0
  filename         = "slack-notifier.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  function_name    = "${local.instance_alias}-slack-notifier"
  role             = aws_iam_role.beekeeper_slack_notifier_lambda[count.index].arn
  handler          = "slack-notifier.lambda_handler"
  runtime          = "python3.7"
  timeout          = 20
  tags             = var.beekeeper_tags

  environment {
    variables = {
      slackChannel    = var.slack_channel
      slackWebhookUrl = var.slack_webhook_url
      account         = data.aws_iam_account_alias.current.account_alias
    }
  }

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = [aws_security_group.beekeeper_sg.id]
  }
}

resource "aws_lambda_permission" "beekeeper_slack_notifier" {
  count         = var.slack_lambda_enabled == 1 ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.beekeeper_slack_notifier[count.index].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.beekeeper_sqs_dlq[count.index].arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/files/slack-notifier.py"
  output_path = "${path.cwd}/slack-notifier.zip"
}
