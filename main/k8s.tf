
variable "k8s_namespace" {}

variable "beekeeper_application_version" {}

variable "k8s_replica_count" {}

variable "k8s_iam_role" {}

locals {
    app_name = "beekeeper"
    scheduler = "path-scheduler"
    cleaner = "cleanup"
}

resource "kubernetes_config_map" "beekeeper" {
    metadata {
        name = "${local.app_name}"
    }

    data = {
        "${locals.scheduler}-properties" = "${data.template_file.beekeeper_path_scheduler_config}"
        "${locals.cleaner}-properties" = "${data.template_file.beekeeper_cleanup_config}"
    }
}

resource "kubernetes_deployment" "beekeeper" {
    metadata {
        name = "${local.app_name}"
        namespace = "${var.namespace}"

        labels = {
            "app.kubernetes.io/name" = "${local.app_name}"
            "app.kubernetes.io/instance" = "${var.apiary}"
            "app.kubernetes.io/version" = "${var.beekeeper_application_version}"
            "app.kubernetes.io/managed-by" = "${var.apiary}"
        }
    }

    spec {
        replicas = "${var.k8s_replica_count}"
        selector {
            match_labels = {
              "app.kubernetes.io/name" = "${local.app_name}"
              "app.kubernetes.io/instance" = ""
            }
        }

        template {
            metadata {
                labels = {
                    "app.kubernetes.io/name" = "${local.app_name}"
                    "app.kubernetes.io/instance" = ""
                }
                annotations = {
                    "iam.amazonaws.com/role" = "${var.k8s_iam_role}"
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
                    name = "${local.app_name}-${locals.scheduler}"
                    image = ""
                    image_pull_policy = ".Values.pull.policy"
                    
                    port {
                        name = "${locals.scheduler}"
                        container_port = "${var.Values.pathScheduler.image.port}"
                    }

                    liveness_probe {
                        http_get {
                            path = "/actuator/health"
                            port = "${locals.scheduler}"
                        }
                        initial_delay_seconds = 60
                    }

                    resources {
                        limits {
                            memory = "${var.memory}"
                            cpu = "${var.cpu}"
                        }
                        requests {
                            memory = "${var.memory}"
                            cpu = "${var.cpu}"
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
                                name = "${kubernetes_config_map.beekeeper.name}"
                                key = "${locals.scheduler}-properties"
                            }
                        }
                    }        
                }

                container {
                    name = "beekeeper-cleanup"
                    image = ""
                    image_pull_policy = ".Values.pull.policy"
                    
                    port {
                        name = "${locals.cleaner}"
                        container_port = "${var.Values.cleanup.image.port}"
                    }

                    liveness_probe {
                        http_get {
                            path = "/actuator/health"
                            port = "{locals.cleaner}"
                        }
                        initial_delay_seconds = 60
                    }

                    resources {
                        limits {
                            memory = "${var.memory}"
                            cpu = "${var.cpu}"
                        }
                        requests {
                            memory = "${var.memory}"
                            cpu = "${var.cpu}"
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
                                name = "${kubernetes_config_map.beekeeper.name}"
                                key = "${locals.cleaner}-properties"
                            }
                        }
                    }        
                }
            }
        }
    }
}


resource "kubernetes_service" "beekeeper" {
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


resource "kubernetes_ingress" "beekeeper" {

}

