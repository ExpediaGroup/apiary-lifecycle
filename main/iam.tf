# ECS execution role

resource "aws_iam_role" "beekeeper-ecs-task-exec" {
  name = "beekeeper-ecs-task-exec-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper-ecs-task-exec" {
  role       = "${aws_iam_role.beekeeper-ecs-task-exec.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Path Scheduler ECS task role

resource "aws_iam_role" "beekeeper-path-scheduler-ecs-task" {
  name = "beekeeper-path-scheduler-ecs-task-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "beekeeper-path-scheduler" {
  name = "beekeeper-path-scheduler-${var.region}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [ 
      {
        "Effect": "Allow",
        "Action": [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        "Resource": "${aws_sqs_queue.beekeeper.arn}"
      },
      {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:bdp-beekeeper-*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper-path-scheduler" {
  role       = "${aws_iam_role.beekeeper-path-scheduler-ecs-task.id}"
  policy_arn = "${aws_iam_policy.beekeeper-path-scheduler.arn}"
}

# Cleanup ECS task role

resource "aws_iam_role" "beekeeper-cleanup-ecs-task" {
  name = "beekeeper-cleanup-ecs-task-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "beekeeper-cleanup" {
  name = "beekeeper-cleanup-${var.region}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:DeleteObject*",
              "s3:Get*",
              "s3:List*"
          ],
          "Resource": [${var.cleanup-buckets}]
      },
      {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:bdp-beekeeper-*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper-cleanup" {
  role       = "${aws_iam_role.beekeeper-cleanup-ecs-task.id}"
  policy_arn = "${aws_iam_policy.beekeeper-cleanup.arn}"
}
