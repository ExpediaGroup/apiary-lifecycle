/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  path_cleanup_name      = "path-cleanup"
  path_cleanup_full_name = "${local.k8s_app_alias}-path-cleanup"
  path_cleanup_labels = {
    "app.kubernetes.io/name"       = "${local.k8s_app_alias}-path-cleanup"
    "app.kubernetes.io/instance"   = "${local.k8s_app_alias}-path-cleanup"
    "app.kubernetes.io/version"    = var.path_cleanup_docker_image_version
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
  path_cleanup_label_name_instance = {
    "app.kubernetes.io/name"     = "${local.k8s_app_alias}-path-cleanup"
    "app.kubernetes.io/instance" = "${local.k8s_app_alias}-path-cleanup"
  }
}

resource "kubernetes_deployment" "beekeeper_path_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.path_cleanup_full_name
    namespace = var.k8s_namespace
    labels = local.path_cleanup_labels
  }

  spec {
    # setting the number of replicas to greater than 1 is currently untested
    replicas = 1
    selector {
      match_labels = local.path_cleanup_label_name_instance
    }

    template {
      metadata {
        labels = local.path_cleanup_label_name_instance
        annotations = {
          "iam.amazonaws.com/role" = aws_iam_role.beekeeper_k8s_role_path_cleanup_iam[count.index].arn
          "prometheus.io/scrape" : var.prometheus_enabled
          "prometheus.io/port" : var.k8s_path_cleanup_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
        container {
          name              = local.path_cleanup_full_name
          image             = "${var.path_cleanup_docker_image}:${var.path_cleanup_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            name           = local.path_cleanup_name
            container_port = var.k8s_path_cleanup_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.path_cleanup_name
            }
            initial_delay_seconds = var.k8s_path_cleanup_liveness_delay
          }

          resources {
            limits {
              memory = var.k8s_path_cleanup_memory
              cpu    = var.k8s_path_cleanup_cpu
            }
            requests {
              memory = var.k8s_path_cleanup_memory
              cpu    = var.k8s_path_cleanup_cpu
            }
          }

          env {
            name  = local.aws_region_key
            value = var.aws_region
          }

          env {
            name  = local.aws_default_region_key
            value = var.aws_region
          }

          env {
            name = local.db_password_key
            value_from {
              secret_key_ref {
                name = var.k8s_db_password_secret
                key  = local.db_password_key
              }
            }
          }

          env {
            name  = local.spring_application_json_key
            value = data.template_file.beekeeper_path_cleanup_config.rendered
          }
        }
        image_pull_secrets {
          name = var.docker_registry_secret_name
        }
      }
    }
  }

}

resource "kubernetes_service" "beekeeper_path_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name   = local.path_cleanup_full_name
    labels = local.path_cleanup_labels
  }

  spec {
    port {
      name        = local.path_cleanup_name
      target_port = local.path_cleanup_name
      port        = var.k8s_path_cleanup_port
    }

    selector = local.path_cleanup_label_name_instance
    type     = "ClusterIP"
  }
}
