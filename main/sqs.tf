resource "aws_sqs_queue" "beekeeper" {
  name                      = "${var.queue-name}"
  message_retention_seconds = "${var.message-retention-seconds}"
  receive_wait_time_seconds = "${var.receive-wait-time-seconds}"
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.beekeeper-dead-letter.arn}\",\"maxReceiveCount\":4}"
  tags                      = "${merge(var.tags)}"
}

resource "aws_sqs_queue" "beekeeper-dead-letter" {
  name                      = "${var.queue-name}-dead-letter"
  message_retention_seconds = "${var.message-retention-seconds}"
  receive_wait_time_seconds = "${var.receive-wait-time-seconds}"
  tags                      = "${merge(var.tags)}"
}

resource "aws_sns_topic_subscription" "beekeeper-apiary" {
  topic_arn = "${var.apiary-metastore-listener-arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.beekeeper.arn}"
}

resource "aws_sqs_queue_policy" "beekeeper" {
  queue_url = "${aws_sqs_queue.beekeeper.id}"
  policy = <<POLICY
          {
            "Version": "2012-10-17",
            "Id": "sqspolicy",
            "Statement": [
              {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "sqs:SendMessage",
                "Resource": "${aws_sqs_queue.beekeeper-dead-letter.arn}",
                "Condition": {
                  "ArnEquals": {
                    "aws:SourceArn": "${var.apiary-metastore-listener-arn}"
                  }
                }
              }
            ]
          }
          POLICY
}
