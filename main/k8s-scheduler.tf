locals {
  scheduler_name      = "path-scheduler"
  scheduler_full_name = "${var.k8s_app_name}-path-scheduler"
  scheduler_labels = {
    "app.kubernetes.io/name"       = "${var.k8s_app_name}-path-scheduler"
    "app.kubernetes.io/instance"   = "${var.k8s_app_name}-path-scheduler"
    "app.kubernetes.io/version"    = var.cleanup_docker_image_version
    "app.kubernetes.io/managed-by" = var.k8s_app_name
  }
  scheduler_label_name_instance = {
    "app.kubernetes.io/name"     = "${var.k8s_app_name}-path-scheduler"
    "app.kubernetes.io/instance" = "${var.k8s_app_name}-path-scheduler"
  }
}

resource "kubernetes_deployment" "beekeeper_scheduler" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.scheduler_full_name
    namespace = var.k8s_namespace
    labels    = local.scheduler_labels
  }

  spec {
    replicas = var.k8s_scheduler_name_replicas
    selector {
      match_labels = local.scheduler_label_name_instance
    }

    template {
      metadata {
        labels = local.scheduler_label_name_instance
        annotations = {
          "iam.amazonaws.com/role" = aws_iam_role.beekeeper_k8s_role[count.index].arn
        }
      }

      spec {
        image_pull_secrets {
          name = var.k8s_image_pull_secret
        }

        container {
          name              = local.scheduler_full_name
          image             = "${var.path_scheduler_docker_image}:${var.path_scheduler_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            name           = local.scheduler_name
            container_port = var.k8s_cleanup_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = var.k8s_scheduler_port
            }
            initial_delay_seconds = var.k8s_scheduler_liveness_delay
          }

          resources {
            limits {
              memory = var.k8s_scheduler_memory
              cpu    = var.k8s_scheduler_cpu
            }
            requests {
              memory = var.k8s_scheduler_memory
              cpu    = var.k8s_scheduler_cpu
            }
          }

          env {
            name  = "AWS_REGION"
            value = var.aws_region
          }

          env {
            name  = "AWS_DEFAULT_REGION"
            value = var.aws_region
          }

          env {
            name  = "DB_PASSWORD_STRATEGY"
            value = var.db_password_strategy
          }

          env {
            name  = "DB_PASSWORD_KEY"
            value = var.db_password_key
          }

          env {
            name = "BEEKEEPER_CONFIG"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.beekeeper[count.index].metadata.name
                key  = "${local.scheduler_full_name}.properties"
              }
            }
          }
        }
      }
    }
  }

}

resource "kubernetes_service" "beekeeper_scheduler" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name   = "beekeeper"
    labels = local.scheduler_labels
  }
  spec {
    port {
      name        = local.scheduler_name
      target_port = local.scheduler_name
      port        = var.k8s_scheduler_port
    }
    selector = local.scheduler_label_name_instance
    type     = "ClusterIP"
  }
}

