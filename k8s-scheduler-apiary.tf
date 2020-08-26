/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  scheduler_apiary_name      = "scheduler-apiary"
  scheduler_apiary_full_name = "${local.k8s_app_alias}-scheduler-apiary"
  scheduler_apiary_labels = {
    "app.kubernetes.io/name"       = "${local.k8s_app_alias}-scheduler-apiary"
    "app.kubernetes.io/instance"   = "${local.k8s_app_alias}-scheduler-apiary"
    "app.kubernetes.io/version"    = var.scheduler_apiary_docker_image_version
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
  scheduler_apiary_label_name_instance = {
    "app.kubernetes.io/name"     = "${local.k8s_app_alias}-scheduler-apiary"
    "app.kubernetes.io/instance" = "${local.k8s_app_alias}-scheduler-apiary"
  }
}

resource "kubernetes_deployment" "beekeeper_scheduler_apiary" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.scheduler_apiary_full_name
    namespace = var.k8s_namespace
    labels    = local.scheduler_apiary_labels
  }

  spec {
    # setting the number of replicas to greater than 1 is currently untested
    replicas = 1
    selector {
      match_labels = local.scheduler_apiary_label_name_instance
    }

    template {
      metadata {
        labels = local.scheduler_apiary_label_name_instance
        annotations = {
          "iam.amazonaws.com/role" = aws_iam_role.beekeeper_k8s_role_scheduler_apiary_iam[count.index].arn
          "prometheus.io/scrape": var.prometheus_enabled
          "prometheus.io/port": var.k8s_scheduler_apiary_port
          "prometheus.io/path": "/actuator/prometheus"
        }
      }

      spec {
        container {
          name              = local.scheduler_apiary_full_name
          image             = "${var.scheduler_apiary_docker_image}:${var.scheduler_apiary_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            container_port = var.k8s_scheduler_apiary_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = var.k8s_scheduler_apiary_port
            }
            initial_delay_seconds = var.k8s_scheduler_apiary_liveness_delay
          }

          resources {
            limits {
              memory = var.k8s_scheduler_apiary_memory
              cpu    = var.k8s_scheduler_apiary_cpu
            }
            requests {
              memory = var.k8s_scheduler_apiary_memory
              cpu    = var.k8s_scheduler_apiary_cpu
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
            name  = "BEEKEEPER_CONFIG"
            value = base64encode(data.template_file.beekeeper_scheduler_apiary_config.rendered)
          }
        }
      }
    }
  }

}

resource "kubernetes_service" "beekeeper_scheduler_apiary" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name   = local.scheduler_apiary_full_name
    labels = local.scheduler_apiary_labels
  }
  spec {
    port {
      name        = local.scheduler_apiary_name
      target_port = var.k8s_scheduler_apiary_port
      port        = var.k8s_scheduler_apiary_port
    }
    selector = local.scheduler_apiary_label_name_instance
    type     = "ClusterIP"
  }
}
