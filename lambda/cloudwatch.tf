resource "aws_cloudwatch_metric_alarm" "beekeeper-sqs-dlq" {
  alarm_name          = "${var.queue-name}-dlq-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This alarm monitors the number of messages in the Beekeeper SQS dead letter queue."
  alarm_actions       = ["${aws_sns_topic.beekeeper-sqs-dlq.arn}"]
  treat_missing_data  = "notBreaching"
  tags                = "${var.tags}"

  dimensions = {
    QueueName = "${var.queue-name}-dead-letter"
  }
}
