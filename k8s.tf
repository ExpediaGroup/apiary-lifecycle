/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  labels = {
    "app.kubernetes.io/name"       = local.k8s_app_alias
    "app.kubernetes.io/instance"   = local.k8s_app_alias
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
}

resource "kubernetes_ingress" "beekeeper" {
  count = var.instance_type == "k8s" && var.k8s_ingress_enabled == 1 ? 1 : 0
  metadata {
    name        = local.k8s_app_alias
    labels      = local.labels
    annotations = {}
    namespace = var.k8s_namespace
  }

  spec {
    tls {
      hosts       = var.k8s_ingress_tls_hosts
      secret_name = var.k8s_ingress_tls_secret
    }

    rule {
      host = "${local.path_cleanup_full_name}.${local.dnsname}.${local.dnsdomain}"
      http {
        path {
          path = "/"
          backend {
            service_name = "beekeeper-path-cleanup"
            service_port = var.k8s_path_cleanup_port
          }
        }
      }
    }

    rule {
      host = var.k8s_metadata_cleanup_ingress_host
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

    rule {
      host = var.k8s_scheduler_apiary_ingress_host
      http {
        path {
          path = var.k8s_scheduler_apiary_ingress_path
          backend {
            service_name = kubernetes_service.beekeeper_scheduler_apiary[count.index].metadata.name
            service_port = kubernetes_service.beekeeper_scheduler_apiary[count.index].spec.port.target_port
          }
        }
      }
    }
  }
}
