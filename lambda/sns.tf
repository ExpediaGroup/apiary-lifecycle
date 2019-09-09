resource "aws_sns_topic" "beekeeper-sqs-dlq" {
  name = "beekeeper-sqs-dlq-alerts"
  tags = "${var.tags}"
}

resource "aws_sns_topic_subscription" "beekeeper-sqs-dlq" {
  topic_arn = "${aws_sns_topic.beekeeper-sqs-dlq.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.beekeeper-slack-notifier.arn}"
}
