resource "aws_db_instance" "beekeeper-mysql" {
  allocated_storage         = "${var.allocated-storage}"
  storage_type              = "${var.storage-type}"
  engine                    = "mysql"
  engine_version            = "${var.engine-version}"
  instance_class            = "${var.instance-class}"
  identifier                = "${var.tags["Name"]}"
  name                      = "beekeeper"
  username                  = "${var.username}"
  password                  = "${data.aws_secretsmanager_secret_version.beekeeper-db.secret_string}"
  parameter_group_name      = "${var.parameter-group-name}"
  db_subnet_group_name      = "${var.rds-subnet-group-name}"
  vpc_security_group_ids    = ["${data.aws_security_group.security-groups.id}"]
  final_snapshot_identifier = "${var.tags["Name"]}-final-snapshot"
  tags                      = "${merge(var.tags)}"
}
