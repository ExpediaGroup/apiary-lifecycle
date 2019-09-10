data "aws_iam_role" "beekeeper-ecs-task-exec" {
  name = "beekeeper-ecs-task-exec-${var.region}"
}

data "aws_iam_role" "beekeeper-path-scheduler-apiary-ecs-task" {
  name = "beekeeper-path-scheduler-ecs-task-${var.region}"
}

data "aws_iam_role" "beekeeper-cleanup-ecs-task" {
  name = "beekeeper-cleanup-ecs-task-${var.region}"
}
