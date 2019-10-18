/**
 * Copyright (C) 2018-2019 Expedia Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_sqs_queue" "beekeeper" {
  name                      = "${var.queue_name}"
  message_retention_seconds = "${var.message_retention_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.beekeeper_dead_letter.arn}\",\"maxReceiveCount\":4}"
  tags                      = "${var.beekeeper_tags}"
}

resource "aws_sqs_queue" "beekeeper_dead_letter" {
  name                      = "${var.queue_name}-dead-letter"
  message_retention_seconds = "${var.message_retention_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
  tags                      = "${var.beekeeper_tags}"
}

resource "aws_sns_topic_subscription" "beekeeper_apiary" {
  topic_arn = "${var.apiary_metastore_listener_arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.beekeeper.arn}"
}

resource "aws_sqs_queue_policy" "beekeeper" {
  queue_url = "${aws_sqs_queue.beekeeper.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Allow Apiary Metadata Events",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.beekeeper.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.apiary_metastore_listener_arn}"
        }
      }
    }
  ]
}
POLICY
}
