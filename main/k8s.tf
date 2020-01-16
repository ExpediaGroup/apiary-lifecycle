locals {
  labels = {
    "app.kubernetes.io/name"       = var.k8s_app_name
    "app.kubernetes.io/instance"   = var.k8s_app_name
    "app.kubernetes.io/managed-by" = var.k8s_app_name
  }
}

resource "kubernetes_config_map" "beekeeper" {
  count = var.instance_type == "k8s" ? 1 : 0
  metadata {
    name = var.k8s_app_name
  }

  data = {
    "${local.scheduler_name}.properties" = data.template_file.beekeeper_path_scheduler_config
    "${local.cleanup_name}.properties"   = data.template_file.beekeeper_cleanup_config
  }
}

resource "kubernetes_ingress" "beekeeper" {
  count = var.instance_type == "k8s" && var.k8s_ingress_enabled == 1 ? 1 : 0
  metadata {
    name        = var.k8s_app_name
    labels      = local.labels
    annotations = {}
  }

  spec {
    tls {
      hosts       = var.k8s_ingress_tls_hosts
      secret_name = var.k8s_ingress_tls_secret
    }

    rule {
      host = var.k8s_cleanup_ingress_host
      http {
        path {
          path = var.k8s_cleanup_ingress_path
          backend {
            service_name = kubernetes_service.beekeeper_cleanup[count.index].metadata.name
            service_port = kubernetes_service.beekeeper_cleanup[count.index].spec.port.target_port
          }
        }
      }
    }

    rule {
      host = var.k8s_scheduler_ingress_host
      http {
        path {
          path = var.k8s_scheduler_ingress_path
          backend {
            service_name = kubernetes_service.beekeeper_scheduler[count.index].metadata.name
            service_port = kubernetes_service.beekeeper_scheduler[count.index].spec.port.target_port
          }
        }
      }
    }
  }
}

