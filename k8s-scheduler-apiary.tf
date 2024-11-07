/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  scheduler_apiary_name      = "scheduler-apiary"
  scheduler_apiary_full_name = "${local.k8s_app_alias}-scheduler-apiary"
  scheduler_apiary_labels = {
    "app.kubernetes.io/name"       = local.scheduler_apiary_full_name
    "app.kubernetes.io/instance"   = local.scheduler_apiary_full_name
    "app.kubernetes.io/version"    = var.scheduler_apiary_docker_image_version
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
  scheduler_apiary_label_name_instance = {
    "app.kubernetes.io/name"     = local.scheduler_apiary_full_name
    "app.kubernetes.io/instance" = local.scheduler_apiary_full_name
  }
}

resource "kubernetes_deployment_v1" "beekeeper_scheduler_apiary" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.scheduler_apiary_full_name
    namespace = var.k8s_namespace
    labels    = local.scheduler_apiary_labels
  }

  spec {
    # setting the number of replicas to greater than 1 is currently untested
    replicas = var.k8s_scheduler_apiary_replicas
    selector {
      match_labels = local.scheduler_apiary_label_name_instance
    }

    template {
      metadata {
        labels = local.scheduler_apiary_label_name_instance
        annotations = {
          "ad.datadoghq.com/${local.scheduler_apiary_full_name}.check_names": "[\"openmetrics\"]"
          "ad.datadoghq.com/${local.scheduler_apiary_full_name}.init_configs": "[{}]"
          "ad.datadoghq.com/${local.scheduler_apiary_full_name}.instances": "[{ \"prometheus_url\": \"http://%%host%%:8080/actuator/prometheus\", \"namespace\": \"${local.instance_alias}\", \"metrics\": [ \"${join("\",\"", var.beekeeper_scheduler_apiary_metrics)}\"]  }]"
          "prometheus.io/scrape" : var.prometheus_enabled
          "prometheus.io/port" : var.k8s_scheduler_apiary_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account_v1.beekeeper_scheduler_apiary.metadata.0.name
        automount_service_account_token = true
        container {
          name              = local.scheduler_apiary_full_name
          image             = "${var.scheduler_apiary_docker_image}:${var.scheduler_apiary_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            container_port = var.k8s_scheduler_apiary_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = var.k8s_scheduler_apiary_port
            }
            initial_delay_seconds = var.k8s_scheduler_apiary_liveness_delay
          }

          resources {
            limits = {
              memory = var.k8s_scheduler_apiary_memory
              cpu    = var.k8s_scheduler_apiary_cpu
            }
            requests = {
              memory = var.k8s_scheduler_apiary_memory
              cpu    = var.k8s_scheduler_apiary_cpu
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
            value = data.template_file.beekeeper_scheduler_apiary_config.rendered
          }

          env {
            name = "HADOOP_USER_NAME"
            value = "beekeeper"
          }
        }
        image_pull_secrets {
          name = var.docker_registry_secret_name
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
    namespace = var.k8s_namespace
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

resource "kubernetes_service_account_v1" "beekeeper_scheduler_apiary" {
  metadata {
    name        = local.scheduler_apiary_full_name
    namespace   = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.beekeeper_k8s_role_scheduler_apiary_iam[0].arn
    }
  }
}

resource "kubernetes_secret_v1" "beekeeper_scheduler_apiary" {
  metadata {
    name        = local.scheduler_apiary_full_name
    namespace   = var.k8s_namespace
    annotations = {
      "kubernetes.io/service-account.name" = local.scheduler_apiary_full_name
      "kubernetes.io/service-account.namespace" = var.k8s_namespace
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [
    kubernetes_service_account_v1.beekeeper_scheduler_apiary
  ]
}