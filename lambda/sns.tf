/**
 * Copyright (C) 2018-2019 Expedia Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_sns_topic" "beekeeper_sqs_dlq" {
  name = "${local.instance_alias}-sqs-dlq-alerts"
  tags = "${var.beekeeper_tags}"
}

resource "aws_sns_topic_subscription" "beekeeper_sns_alerts_lambda" {
  topic_arn = "${aws_sns_topic.beekeeper_sqs_dlq.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.beekeeper_slack_notifier.arn}"
}
