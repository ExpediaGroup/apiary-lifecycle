resource "aws_ecs_cluster" "beekeeper" {
  name = "beekeeper"
  tags = "${var.tags}"
}

resource "aws_ecs_service" "beekeeper-path-scheduler-apiary" {
  name            = "beekeeper-path-scheduler-apiary"
  cluster         = "${aws_ecs_cluster.beekeeper.id}"
  task_definition = "${aws_ecs_task_definition.beekeeper-path-scheduler-apiary.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${data.aws_security_group.sg_expedia.id}"]
    subnets         = ["${data.aws_subnet_ids.backend_subnets.ids}"]
  }
}

resource "aws_ecs_service" "beekeeper-cleanup" {
  name            = "beekeeper-cleanup"
  cluster         = "${aws_ecs_cluster.beekeeper.id}"
  task_definition = "${aws_ecs_task_definition.beekeeper-cleanup.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${data.aws_security_group.sg_expedia.id}"]
    subnets         = ["${data.aws_subnet_ids.backend_subnets.ids}"]
  }
}

resource "aws_ecs_task_definition" "beekeeper-path-scheduler-apiary" {
  family                   = "beekeeper"
  execution_role_arn       = "${data.aws_iam_role.beekeeper-ecs-task-exec.arn}"
  task_role_arn            = "${data.aws_iam_role.beekeeper-path-scheduler-apiary-ecs-task.arn}"
  container_definitions    = "${data.template_file.beekeeper-path-scheduler-apiary-container-definition.rendered}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = "${var.path-scheduler-apiary-cpu}"
  memory                   = "${var.path-scheduler-apiary-memory}"
  tags                     = "${var.tags}"
}

resource "aws_ecs_task_definition" "beekeeper-cleanup" {
  family                   = "beekeeper"
  execution_role_arn       = "${data.aws_iam_role.beekeeper-ecs-task-exec.arn}"
  task_role_arn            = "${data.aws_iam_role.beekeeper-cleanup-ecs-task.arn}"
  container_definitions    = "${data.template_file.beekeeper-cleanup-container-definition.rendered}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2", "FARGATE"]
  cpu                      = "${var.cleanup-cpu}"
  memory                   = "${var.cleanup-memory}"
  tags                     = "${var.tags}"
}

resource "aws_cloudwatch_log_group" "beekeeper-path-scheduler-apiary" {
  name = "beekeeper-path-scheduler-apiary"
  tags = "${var.tags}"
}

resource "aws_cloudwatch_log_group" "beekeeper-cleanup" {
  name = "beekeeper-cleanup"
  tags = "${var.tags}"
}
