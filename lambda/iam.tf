resource "aws_iam_role" "beekeeper-slack-notifier-lambda" {
  name  = "beekeeper-slack-notifier-lambda-${var.region}"
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

resource "aws_iam_role_policy_attachment" "beekeeper-slack-notifier-lambda" {
  role       = "${aws_iam_role.beekeeper-slack-notifier-lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}