resource "kubernetes_secret" "beekeeper_db_password_secret" {
  metadata {
    name      = var.k8s_db_password_secret
    namespace = var.k8s_namespace
  }

  data = {
    "${local.db_password_key}" = chomp(data.aws_secretsmanager_secret_version.beekeeper_db.secret_string)
  }
}