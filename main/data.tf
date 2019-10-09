data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc-name}"]
  }
}

data "aws_subnet_ids" "subnet-ids" {
  filter {
    name   = "tag:Name"
    values = "${var.subnet-names}"
  }

  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_security_group" "security-groups" {
  filter {
    name   = "tag:Name"
    values = "${var.security-group-names}"
  }
}

data "aws_secretsmanager_secret" "beekeeper-db" {
  name        = "${var.db-password-key}"	
}
