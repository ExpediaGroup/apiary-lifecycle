####################################################
# Beekeeper ECS execution role
####################################################

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

resource "aws_iam_role_policy" "beekeeper-ecs-task-exec-secrets" {
  name = "beekeeper-ecs-task-exec-secrets"
  role = "${aws_iam_role.beekeeper-ecs-task-exec.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [ 
      {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:bdp-beekeeper-*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper-ecs-task-exec" {
  role       = "${aws_iam_role.beekeeper-ecs-task-exec.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

####################################################
# End of Beekeeper ECS execution role
####################################################

###############################################################
# Beekeeper Path Scheduler ECS task role
###############################################################

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

resource "aws_iam_role_policy" "beekeeper-path-scheduler-ecs-sqs" {
  name = "beekeeper-path-scheduler-ecs-sqs"
  role = "${aws_iam_role.beekeeper-path-scheduler-ecs-task.id}"

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

###############################################################
# End of Beekeeper Path Scheduler Apiary ECS task role
###############################################################

####################################################
# Beekeeper Cleanup ECS roles
####################################################

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

resource "aws_iam_role_policy" "beekeeper-cleanup-ecs-s3" {
  name = "beekeeper-cleanup-ecs-s3"
  role = "${aws_iam_role.beekeeper-cleanup-ecs-task.id}"

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

####################################################
# End of Beekeeper Cleanup ECS roles
####################################################