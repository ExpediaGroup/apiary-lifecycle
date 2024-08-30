/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  metadata_cleanup_name      = "metadata-cleanup"
  metadata_cleanup_full_name = "${local.k8s_app_alias}-metadata-cleanup"
  metadata_cleanup_labels = {
    "app.kubernetes.io/name"       = local.metadata_cleanup_full_name
    "app.kubernetes.io/instance"   = local.metadata_cleanup_full_name
    "app.kubernetes.io/version"    = var.metadata_cleanup_docker_image_version
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
  metadata_cleanup_label_name_instance = {
    "app.kubernetes.io/name"     = local.metadata_cleanup_full_name
    "app.kubernetes.io/instance" = local.metadata_cleanup_full_name
  }
}

resource "kubernetes_deployment_v1" "beekeeper_metadata_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.metadata_cleanup_full_name
    namespace = var.k8s_namespace
    labels    = local.metadata_cleanup_labels
  }

  spec {
    # setting the number of replicas to greater than 1 is currently untested
    replicas = 1
    selector {
      match_labels = local.metadata_cleanup_label_name_instance
    }

    template {
      metadata {
        labels = local.metadata_cleanup_label_name_instance
        annotations = {
          "ad.datadoghq.com/${local.metadata_cleanup_full_name}.check_names": "[\"openmetrics\"]"
          "ad.datadoghq.com/${local.metadata_cleanup_full_name}.init_configs": "[{}]"
          "ad.datadoghq.com/${local.metadata_cleanup_full_name}.instances": "[{ \"prometheus_url\": \"http://%%host%%:9008/actuator/prometheus\", \"namespace\": \"${local.instance_alias}\", \"metrics\": [\"s3_bytes_deleted_bytes_total*\", \"hive_table_metadata_deleted_total*\",\"hive_partition_metadata_deleted_total*\",\"s3_paths_deleted_seconds_sum*\", \"s3_paths_deleted_seconds_count*\", \"metadata_cleanup_job_seconds_sum*\", \"hive_table_deleted_seconds_count*\", \"disk_*\", \"jvm*\", \"hikaricp*\"] }]"
          "prometheus.io/scrape" : var.prometheus_enabled
          "prometheus.io/port" : var.k8s_metadata_cleanup_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account_v1.beekeeper_metadata_cleanup.metadata.0.name
        automount_service_account_token = true
        container {
          name              = local.metadata_cleanup_full_name
          image             = "${var.metadata_cleanup_docker_image}:${var.metadata_cleanup_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            container_port = var.k8s_metadata_cleanup_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = var.k8s_metadata_cleanup_port
            }
            initial_delay_seconds = var.k8s_metadata_cleanup_liveness_delay
          }

          resources {
            limits = {
              memory = var.k8s_metadata_cleanup_memory
              cpu    = var.k8s_metadata_cleanup_cpu
            }
            requests = {
              memory = var.k8s_metadata_cleanup_memory
              cpu    = var.k8s_metadata_cleanup_cpu
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
            value = data.template_file.beekeeper_metadata_cleanup_config.rendered
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

resource "kubernetes_service" "beekeeper_metadata_cleanup" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name   = local.metadata_cleanup_full_name
    labels = local.metadata_cleanup_labels
    namespace = var.k8s_namespace
  }

  spec {
    port {
      name        = local.metadata_cleanup_name
      target_port = var.k8s_metadata_cleanup_port
      port        = var.k8s_metadata_cleanup_port
    }

    selector = local.metadata_cleanup_label_name_instance
    type     = "ClusterIP"
  }
}

resource "kubernetes_service_account_v1" "beekeeper_metadata_cleanup" {
  metadata {
    name        = local.metadata_cleanup_full_name
    namespace   = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.beekeeper_k8s_role_metadata_cleanup_iam[0].arn
    }
  }
}

resource "kubernetes_secret_v1" "beekeeper_metadata_cleanup" {
  metadata {
    name        = local.metadata_cleanup_full_name
    namespace   = var.k8s_namespace
    annotations = {
      "kubernetes.io/service-account.name" = local.metadata_cleanup_full_name
      "kubernetes.io/service-account.namespace" = var.k8s_namespace
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [
    kubernetes_service_account_v1.beekeeper_metadata_cleanup
  ]
}
