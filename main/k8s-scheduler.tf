variable "k8s_scheduler_memory" {
  description = "Total memory to allot to the Beekeeper scheduler pod"
  default = "2Gi"
  type = string
}

variable "k8s_scheduler_cpu" {
  description = "Total cpu to allot to the Beekeeper scheduler pod"
  default = "500m"
  type = string
}

variable "k8s_scheduler_port" {
  description = "Internal port that the Beekeeper Scheduler service runs on"
  default = 8080
  type = number
}


resource "kubernetes_deployment" "beekeeper_scheduler" {
  metadata {
    name = local.app_name
    namespace = var.k8s_namespace

    labels = {
      "app.kubernetes.io/name" = local.app_name
      "app.kubernetes.io/instance" = var.apiary
      "app.kubernetes.io/version" = var.beekeeper_application_version
      "app.kubernetes.io/managed-by" = var.apiary
    }
  }

  spec {
    replicas = var.k8s_replica_count
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.app_name
        "app.kubernetes.io/instance" = ""
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.app_name
          "app.kubernetes.io/instance" = ""
        }
        annotations = {
          "iam.amazonaws.com/role" = var.k8s_iam_role
        }
      }

      spec {
        image_pull_secrets {
          name = ""
        }

        node_selector = {}
        affinity {}
        toleration {}

        container {
          name = "${local.app_name}-${local.scheduler}"
          image = ""
          image_pull_policy = ".Values.pull.policy"

          port {
            name = local.scheduler
            container_port = var.k8s_scheduler_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.scheduler
            }
            initial_delay_seconds = 60
          }

          resources {
            limits {
              memory = var.k8s_scheduler_memory
              cpu = var.k8s_scheduler_cpu
            }
            requests {
              memory = var.k8s_scheduler_memory
              cpu = var.k8s_scheduler_cpu
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
            value_from {
              secret_key_ref {
                name = kubernetes_secret.beekeeper.metadata.name
                key = "db_password"
              }
            }
            value = var.db_password_key
          }

          env {
            name = "BEEKEEPER_CONFIG"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.beekeeper.metadata.name
                key = "${local.scheduler}.properties"
              }
            }
          }
        }

        container {
          name = "beekeeper-cleanup"
          image = ""
          image_pull_policy = ".Values.pull.policy"

          port {
            name = local.cleaner
            container_port = var.k8s_cleanup_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.cleaner
            }
            initial_delay_seconds = 60
          }

          resources {
            limits {
              memory = var.k8s_cleanup_memory
              cpu = var.k8s_cleanup_cpu
            }
            requests {
              memory = var.memory
              cpu = var.cpu
            }
          }

          env {
            name = "AWS_REGION"
            value = ".Values.image.env.awsRegion"
          }

          env {
            name = "AWS_DEFAULT_REGION"
            value = ".Values.image.env.awsRegion"
          }

          env {
            name = "DB_PASSWORD_STRATEGY"
            value = ".Values.image.env.dbPasswordStrategy"
          }

          env {
            name = "DB_PASSWORD_KEY"
            value = ".Values.image.env.dbPasswordKey"
          }

          env {
            name = "BEEKEEPER_CONFIG"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.beekeeper.metadata.name
                key = lookup(kubernetes_config_map.beekeeper.data, "${local.cleaner}.properties")
              }
            }
          }
        }
      }
    }
  }

}


resource "kubernetes_service" "beekeeper_scheduler" {
  metadata {
    name = "beekeeper"
    labels = {
      "app.kubernetes.io/name" = "beekeeper"
      "app.kubernetes.io/instance" = "${var.apiary}"
      "app.kubernetes.io/version" = "${var.beekeeper_application_version}"
      "app.kubernetes.io/managed-by" = "${var.apiary}"
    }
  }

  spec {
    port {
      name = "path-scheduler"
      target_port = "path-scheduler"
      port = 1
    }

    port {
      name = "cleanup"
      target_port = "cleanup"
      port = 1
    }

    selector = {
      "app.kubernetes.io/name" = "beekeeper"
      "app.kubernetes.io/instance" = ""
    }

    type = ""
  }
}

