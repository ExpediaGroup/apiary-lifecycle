locals {
  cleanup_name = "cleanup"
  cleanup_full_name = "${var.k8s_app_name}-cleanup"
  cleanup_labels = {
    "app.kubernetes.io/name" = "${var.k8s_app_name}-cleanup"
    "app.kubernetes.io/instance" = "${var.k8s_app_name}-cleanup"
    "app.kubernetes.io/version" = var.path_scheduler_docker_image_version
    "app.kubernetes.io/managed-by" = var.k8s_app_name
  }
  cleanup_label_name_instance = {
    "app.kubernetes.io/name" = "${var.k8s_app_name}-cleanup"
    "app.kubernetes.io/instance" = "${var.k8s_app_name}-cleanup"
  }
}

resource "kubernetes_deployment" "beekeeper_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name = local.cleanup_full_name
    namespace = var.k8s_namespace
    labels = local.cleanup_labels
  }

  spec {
    replicas = var.k8s_cleanup_name_replicas
    selector {
      match_labels = local.cleanup_label_name_instance
    }

    template {
      metadata {
        labels = local.cleanup_label_name_instance
        annotations = {
          "iam.amazonaws.com/role" = var.k8s_iam_role
        }
      }

      spec {
        image_pull_secrets {
          name = var.k8s_image_pull_secret
        }

        container {
          name = local.cleanup_full_name
          image = "${var.cleanup_docker_image}:${var.cleanup_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            name = local.cleanup_name
            container_port = var.k8s_cleanup_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.cleanup_name
            }
            initial_delay_seconds = var.k8s_cleanup_liveness_delay
          }

          resources {
            limits {
              memory = var.k8s_cleanup_memory
              cpu = var.k8s_cleanup_cpu
            }
            requests {
              memory = var.k8s_cleanup_memory
              cpu = var.k8s_cleanup_cpu
            }
          }

          env {
            name = "AWS_REGION"
            value = var.aws_region
          }

          env {
            name = "AWS_DEFAULT_REGION"
            value = var.aws_region
          }

          env {
            name = "DB_PASSWORD_STRATEGY"
            value = var.db_password_strategy
          }

          env {
            name = "DB_PASSWORD_KEY"
            value = var.db_password_key
          }

          env {
            name = "BEEKEEPER_CONFIG"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.beekeeper[count.index].metadata.name
                key = "${local.cleanup_full_name}.properties"
              }
            }
          }
        }
      }
    }
  }

}

resource "kubernetes_service" "beekeeper_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name = "beekeeper"
    labels = local.cleanup_labels
  }

  spec {
    port {
      name = local.cleanup_name
      target_port = local.cleanup_name
      port = var.k8s_cleanup_port
    }

    selector = local.cleanup_label_name_instance
    type = "ClusterIP"
  }
}

