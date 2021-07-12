/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  api_name      = "api"
  api_full_name = "${local.k8s_app_alias}-api"
  api_labels = {
    "app.kubernetes.io/name"       = "${local.k8s_app_alias}-api"
    "app.kubernetes.io/instance"   = "${local.k8s_app_alias}-api"
    "app.kubernetes.io/version"    = var.api_docker_image_version
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
  api_label_name_instance = {
    "app.kubernetes.io/name"     = "${local.k8s_app_alias}-api"
    "app.kubernetes.io/instance" = "${local.k8s_app_alias}-api"
  }
}

resource "kubernetes_deployment" "beekeeper_api" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name      = local.api_full_name
    namespace = var.k8s_namespace
    labels    = local.api_labels
  }

  spec {
    # setting the number of replicas to greater than 1 is currently untested
    replicas = 1
    selector {
      match_labels = local.api_label_name_instance
    }

    template {
      metadata {
        labels = local.api_label_name_instance
        annotations = {
          "iam.amazonaws.com/role" = aws_iam_role.beekeeper_k8s_role_api_iam[count.index].arn
          "prometheus.io/scrape" : var.prometheus_enabled
          "prometheus.io/port" : var.k8s_beekeeper_api_port
          "prometheus.io/path" : "/actuator/prometheus"
        }
      }

      spec {
        container {
          name              = local.api_full_name
          image             = "${var.api_docker_image}:${var.api_docker_image_version}"
          image_pull_policy = var.k8s_image_pull_policy

          port {
            container_port = var.k8s_beekeeper_api_port
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = var.k8s_beekeeper_api_port
            }
            failure_threshold     = 11
            initial_delay_seconds = 60
            period_seconds        = 30
          }

          resources {
            limits {
              memory = var.k8s_api_memory
              cpu    = var.k8s_api_cpu
            }
            requests {
              memory = var.k8s_api_memory
              cpu    = var.k8s_api_cpu
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
            value = data.template_file.beekeeper_api_config.rendered
          }
        }
        image_pull_secrets {
          name = var.docker_registry_secret_name
        }
      }
    }
  }

}

resource "kubernetes_service" "beekeeper_api" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name   = local.api_full_name
    labels = local.api_labels
    namespace = var.k8s_namespace
  }

  spec {
    port {
      target_port = var.k8s_beekeeper_api_port
      port        = var.k8s_beekeeper_api_port
    }

    selector = local.api_label_name_instance
    type     = "ClusterIP"
  }
}


resource "kubernetes_ingress" "beekeeper-api" {
  metadata {
    name = local.api_full_name
    namespace = var.k8s_namespace
  }

  spec {
    rule {
      host = "${local.api_full_name}.${local.dnsname}.${local.dnsdomain}"
      http {
        path {
          backend {
            service_name = local.api_full_name
            service_port = var.k8s_beekeeper_api_port
          }
          path = "/"
        }
      }
    }
  }
}
