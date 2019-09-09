resource "aws_lambda_function" "beekeeper-slack-notifier" {
  filename         = "slack-notifier.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  function_name    = "beekeeper-slack-notifier"
  role             = "${data.aws_iam_role.beekeeper-slack-notifier-lambda.arn}"
  handler          = "slack-notifier.lambda_handler"
  runtime          = "python3.7"
  timeout          = 20
  tags             = "${var.tags}"

  environment {
    variables = {
      slackChannel    = "${var.slack-channel}"
      slackWebhookUrl = "${var.slack-webhook-url}"
      account         = "${var.profile}"
    }
  }
}

resource "aws_lambda_permission" "beekeeper-slack-notifier" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.beekeeper-slack-notifier.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.beekeeper-sqs-dlq.arn}"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/slack-notifier.py"
  output_path = "${path.module}/slack-notifier.zip"
}

data "aws_iam_role" "beekeeper-slack-notifier-lambda" {
  name = "beekeeper-slack-notifier-lambda-${var.region}"
}
