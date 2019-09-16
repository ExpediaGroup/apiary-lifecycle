resource "aws_secretsmanager_secret" "beekeeper-db" {
  count = "${var.db-password-strategy == "aws-secrets-manager" ? 1 : 0 }"

  name        = "${var.db-password-key}"
  description = "Password for Beekeeper database"
}

resource "aws_secretsmanager_secret_version" "beekeeper-db" {
  count = "${var.db-password-strategy == "aws-secrets-manager" ? 1 : 0 }"

  secret_id     = "${aws_secretsmanager_secret.beekeeper-db.id}"
  secret_string = "${var.password}"
}
