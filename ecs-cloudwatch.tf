/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "template_file" "ecs_widgets" {
  template = <<EOF
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [ "AWS/ECS", "CPUUtilization", "ServiceName", "${local.instance_alias}-service", "ClusterName", "${local.instance_alias}" ]
             ],
             "period":300,
             "stat":"Average",
             "region":"${var.aws_region}",
             "title":"Beekeeper ECS CPU Utilization"
          }
       },
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${local.instance_alias}-service", "ClusterName", "${local.instance_alias}" ]
             ],
             "period":300,
             "stat":"Average",
             "region":"${var.aws_region}",
             "title":"Beekeeper ECS Memory Utilization"
          }
       },
EOF
}

data "template_file" "sqs_widgets" {
  template = <<EOF
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
             "metrics": [
                 [ "AWS/SQS", "NumberOfMessagesSent", "QueueName", "${var.queue_name}" ],
                 [ "AWS/SQS", "NumberOfMessagesReceived", "QueueName", "${var.queue_name}" ]
             ],
             "period":300,
             "stat":"Average",
             "region": "${var.aws_region}",
             "title": "Beekeeper SQS Sent & Received Messages"
           }
       },
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
        	 "metrics": [
               [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "${var.queue_name}" ],
               [ "AWS/SQS", "ApproximateNumberOfMessagesDelayed", "QueueName", "${var.queue_name}" ],
               [ "AWS/SQS", "ApproximateNumberOfMessagesNotVisible", "QueueName", "${var.queue_name}" ]
              ],
             "period":300,
             "stat":"Average",
             "region": "${var.aws_region}",
             "title": "Beekeeper SQS Queue Size Metrics"
           }
       },
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
             "metrics": [
               [ "AWS/SQS", "NumberOfMessagesDeleted", "QueueName", "${var.queue_name}" ]
             ],
             "period":300,
             "stat":"Average",
             "region": "${var.aws_region}",
             "title": "Beekeeper SQS Deleted Messages"
          }
       },
       {
          "type":"metric",
          "width":12,
          "height":6,
          "properties":{
             "metrics": [
                 [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.queue_name}" ]
             ],
             "period":300,
             "stat":"Average",
             "view": "singleValue",
             "region": "${var.aws_region}",
             "title": "Beekeeper SQS Age of Oldest Message (s)"
           }
       }  
EOF
}

resource "aws_cloudwatch_dashboard" "beekeeper" {
  count          = var.instance_type == "ecs" ? 1 : 0
  dashboard_name = "${local.instance_alias}-${var.aws_region}"

  dashboard_body = <<EOF
 {
   "widgets": [
${join("", data.template_file.ecs_widgets.*.rendered)}
${join("", data.template_file.sqs_widgets.*.rendered)}
   ]
 }
 EOF
}

locals {
  alerts = [
    {
      alarm_name  = "${local.instance_alias}-path-scheduler-cpu"
      namespace   = "AWS/ECS"
      metric_name = "CPUUtilization"
      threshold   = "90"
    },
    {
      alarm_name  = "${local.instance_alias}-path-scheduler-memory"
      namespace   = "AWS/ECS"
      metric_name = "MemoryUtilization"
      threshold   = "80"
    },
    {
      alarm_name  = "${local.instance_alias}-cleanup-cpu"
      namespace   = "AWS/ECS"
      metric_name = "CPUUtilization"
      threshold   = "90"
    },
    {
      alarm_name  = "${local.instance_alias}-cleanup-memory"
      namespace   = "AWS/ECS"
      metric_name = "MemoryUtilization"
      threshold   = "80"
    }
  ]

  dimensions = [
    {
      ClusterName = local.instance_alias
      ServiceName = "${local.instance_alias}-path-scheduler-service"
    },
    {
      ClusterName = local.instance_alias
      ServiceName = "${local.instance_alias}-path-scheduler-service"
    },
    {
      ClusterName = local.instance_alias
      ServiceName = "${local.instance_alias}-cleanup-service"
    },
    {
      ClusterName = local.instance_alias
      ServiceName = "${local.instance_alias}-cleanup-service"
    }
  ]
}

resource "aws_cloudwatch_metric_alarm" "beekeeper_alert" {
  count               = var.instance_type == "ecs" ? length(local.alerts) : 0
  alarm_name          = lookup(local.alerts[count.index], "alarm_name")
  comparison_operator = lookup(local.alerts[count.index], "comparison_operator", "GreaterThanOrEqualToThreshold")
  metric_name         = lookup(local.alerts[count.index], "metric_name")
  namespace           = lookup(local.alerts[count.index], "namespace")
  period              = lookup(local.alerts[count.index], "period", "120")
  evaluation_periods  = lookup(local.alerts[count.index], "evaluation_periods", "2")
  statistic           = "Average"
  threshold           = lookup(local.alerts[count.index], "threshold")

  insufficient_data_actions = []
  dimensions                = local.dimensions[count.index]
  alarm_actions             = [aws_sns_topic.beekeeper_ops_sns.*.arn[0]]
}
