/**
 * Copyright (C) 2019-2020 Expedia, Inc.
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

resource "kubernetes_deployment" "beekeeper_metadata_cleanup" {
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
          "iam.amazonaws.com/role" = aws_iam_role.beekeeper_k8s_role_metadata_cleanup_iam[count.index].arn
          "prometheus.io/scrape" : var.prometheus_enabled
          "prometheus.io/port" : var.k8s_metadata_cleanup_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
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
            limits {
              memory = var.k8s_metadata_cleanup_memory
              cpu    = var.k8s_metadata_cleanup_cpu
            }
            requests {
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

resource "kubernetes_ingress" "beekeeper-metadata-cleanup" {
  count = var.instance_type == "k8s" && var.k8s_ingress_enabledd == 1 ? 1 : 0
  metadata {
    name = local.metadata_cleanup_full_name
    namespace = var.k8s_namespace
  }

  spec {
    rule {
      host = "${local.metadata_cleanup_full_name}.${local.dnsname}.${local.dnsdomain}"
      http {
        path {
          path = var.k8s_metadata_cleanup_ingress_path
          backend {
            service_name = kubernetes_service.beekeeper_metadata_cleanup[count.index].metadata.name
            service_port = kubernetes_service.beekeeper_metadata_cleanup[count.index].spec.port.target_port
          }
        }
      }
    }
  }
}