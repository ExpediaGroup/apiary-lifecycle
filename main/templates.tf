data "template_file" "beekeeper-path-scheduler-apiary-container-definition" {
  template = "${file("${path.module}/ecs-config/container-definition.json")}"

  vars {
    db-password-strategy  = "${var.db-password-strategy}"
    db-password-key       = "${var.db-password-key}"
    docker-image-url      = "${var.path-scheduler-apiary-docker-image-url}"
    beekeeper-config-yaml = "${base64encode(data.template_file.beekeeper-path-scheduler-apiary-config.rendered)}"
    log-group             = "${aws_cloudwatch_log_group.beekeeper-path-scheduler-apiary.name}"
    memory                = "${var.path-scheduler-apiary-memory}"
    name                  = "beekeeper-path-scheduler-apiary"
    port                  = 8080
    region                = "${var.region}"
  }
}

data "template_file" "beekeeper-cleanup-container-definition" {
  template = "${file("${path.module}/ecs-config/container-definition.json")}"

  vars {
    db-password-strategy  = "${var.db-password-strategy}"
    db-password-key       = "${var.db-password-key}"
    docker-image-url      = "${var.cleanup-docker-image-url}"
    beekeeper-config-yaml = "${base64encode(data.template_file.beekeeper-cleanup-config.rendered)}"
    log-group             = "${aws_cloudwatch_log_group.beekeeper-cleanup.name}"
    memory                = "${var.cleanup-memory}"
    name                  = "beekeeper-cleanup"
    port                  = 8008
    region                = "${var.region}"
  }
}

data "template_file" "beekeeper-path-scheduler-apiary-config" {
  template = "${file("${path.module}/ecs-config/beekeeper-path-scheduler-apiary-config.yml")}"

  vars {
    endpoint         = "${aws_db_instance.beekeeper-mysql.endpoint}"
    username         = "${aws_db_instance.beekeeper-mysql.username}"
    queue            = "${aws_sqs_queue.beekeeper.id}"
    graphite-enabled = "${var.graphite-enabled}"
    graphite-host    = "${var.graphite-host}"
    graphite-prefix  = "${var.graphite-prefix}"
    graphite-port    = "${var.graphite-port}"
  }
}

data "template_file" "beekeeper-cleanup-config" {
  template = "${file("${path.module}/ecs-config/beekeeper-cleanup-config.yml")}"

  vars {
    endpoint           = "${aws_db_instance.beekeeper-mysql.endpoint}"
    username           = "${aws_db_instance.beekeeper-mysql.username}"
    graphite-enabled   = "${var.graphite-enabled}"
    graphite-host      = "${var.graphite-host}"
    graphite-prefix    = "${var.graphite-prefix}"
    graphite-port      = "${var.graphite-port}"
    scheduler-delay-ms = "${var.scheduler-delay-ms}"
    dry-run-enabled    = "${var.dry-run-enabled}"
  }
}
