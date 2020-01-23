/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_sns_topic" "beekeeper_sqs_dlq" {
  count = var.slack_lambda_enabled == 1 ? 1 : 0
  name  = "${local.instance_alias}-sqs-dlq-alerts"
  tags  = var.beekeeper_tags
}

resource "aws_sns_topic_subscription" "beekeeper_sns_alerts_lambda" {
  count     = var.slack_lambda_enabled == 1 ? 1 : 0
  topic_arn = aws_sns_topic.beekeeper_sqs_dlq[count.index].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.beekeeper_slack_notifier[count.index].arn
}
