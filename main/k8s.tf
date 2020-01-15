
variable "k8s_namespace" {}

variable "beekeeper_application_version" {}

variable "k8s_replica_count" {}

variable "k8s_iam_role" {}


variable "k8s_node_affinity" {
  
}

variable "k8s_pod_affinity" {

}

variable "k8s_pod_anti_affinity" {
  
}

locals {
    app_name = "beekeeper"
    scheduler = "path-scheduler"
    cleaner = "cleanup"
}

resource "kubernetes_config_map" "beekeeper" {
    metadata {
        name = local.app_name
    }

    data = {
        "${local.scheduler}.properties" = data.template_file.beekeeper_path_scheduler_config
        "${local.cleaner}.properties" = data.template_file.beekeeper_cleanup_config
    }
}

resource "kubernetes_secret" "beekeeper" {
    metadata {
        name = local.app_name
    }

    type = "Opaque"

    data = {
        db_password = var.db_password_key
    }
}



resource "kubernetes_ingress" "beekeeper" {

}

