/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

# Global

variable "instance_name" {
  description = "Beekeeper instance name to identify resources in multi-instance deployments."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Service to run Beekeeper on. Supported services: `ecs` (default), `k8s`. Leaving this blank will still deploy auxiliary components (e.g. RDS, SQS etc.)."
  type        = string
  default     = "ecs"
}

variable "aws_region" {
  description = "AWS region to use for resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to install Beekeeper."
  type        = string
}

variable "subnets" {
  description = "Subnets in which to install Beekeeper."
  type        = list(string)
}

variable "beekeeper_tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
}

# RDS specific

variable "rds_subnets" {
  description = "Subnets in which to provision Beekeeper RDS DB."
  type        = list(string)
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GBs."
  default     = 10
  type        = string
}

variable "rds_max_allocated_storage" {
  description = "RDS max allocated storage (autoscaling) in GBs."
  default     = 100
  type        = string
}

variable "rds_storage_type" {
  description = "RDS storage type."
  default     = "gp2"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class."
  default     = "db.t2.micro"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version."
  default     = "8.0"
  type        = string
}

variable "rds_parameter_group_name" {
  description = "RDS parameter group."
  default     = "default.mysql8.0"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user."
  default     = "beekeeper"
  type        = string
}

variable "db_password_key" {
  description = "Key to acquire the database password for the strategy specified."
  type        = string
}

variable "db_backup_retention" {
  description = "The number of days to retain backups for the RDS Beekeeper DB."
  type        = string
  default     = 10
}

variable "db_backup_window" {
  description = "Preferred backup window for the RDS Beekeeper DB in UTC."
  type        = string
  default     = "02:00-03:00"
}

variable "db_maintenance_window" {
  description = "Preferred maintenance window for the RDS Beekeeper DB in UTC."
  type        = string
  default     = "wed:03:00-wed:04:00"
}

# SQS specific

variable "queue_name" {
  description = "Beekeeper SQS Queue name."
  type        = string
  default     = "apiary-beekeeper"
}

variable "message_retention_seconds" {
  description = "SQS message retention (s)."
  type        = string
  default     = "604800"
}

variable "receive_wait_time_seconds" {
  description = "SQS receive wait time (s)."
  type        = string
  default     = "20"
}

variable "apiary_metastore_listener_arn" {
  description = "ARN of the Apiary Metastore Listener."
  type        = string
}

variable "queue_stale_messages_timeout" {
  description = "Beekeeper SQS Queue Cloudwatch Alert timeout for messages older than this number of seconds."
  type        = string
  default     = "1209600"
}

# ECS specific

variable "scheduler_apiary_docker_image" {
  description = "Beekeeper Scheduler Apiary image."
  type        = string
  default     = "expediagroup/beekeeper-scheduler-apiary"
}

variable "scheduler_apiary_docker_image_version" {
  description = "Beekeeper Scheduler Apiary image version."
  type        = string
  default     = "latest"
}

variable "scheduler_apiary_ecs_cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Scheduler Apiary ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = string
}

variable "scheduler_apiary_ecs_memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Scheduler Apiary container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = string
}

variable "path_cleanup_docker_image" {
  description = "Beekeeper Path Cleanup docker image."
  type        = string
  default     = "expediagroup/beekeeper-path-cleanup"
}

variable "path_cleanup_docker_image_version" {
  description = "Beekeeper Path Cleanup docker image version."
  type        = string
  default     = "latest"
}

variable "path_cleanup_ecs_cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Path Cleanup ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = string
}

variable "path_cleanup_ecs_memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Path Cleanup container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = string
}

variable "metadata_cleanup_docker_image" {
  description = "Beekeeper Metadata Cleanup docker image."
  type        = string
  default     = "expediagroup/beekeeper-metadata-cleanup"
}

variable "metadata_cleanup_docker_image_version" {
  description = "Beekeeper Metadata Cleanup docker image version."
  type        = string
  default     = "latest"
}

variable "docker_registry_secret_name" {
  description = "Docker Registry authentication K8S secret name."
  type        = string
  default     = ""
}

variable "docker_registry_auth_secret_name" {
  description = "Docker Registry authentication SecretManager secret name."
  type        = string
  default     = ""
}

variable "api_docker_image" {
  description = "Beekeeper API image."
  type        = string
  default     = "expediagroup/beekeeper-api"
}

variable "api_docker_image_version" {
  description = "Beekeeper API docker image version."
  type        = string
  default     = "latest"
}

# Application specific

variable "allowed_s3_buckets" {
  description = "List of S3 Buckets to which Beekeeper will have read-write access."
  type        = list(string)
  default     = []
}

variable "scheduler_delay_ms" {
  description = "Delay between each cleanup job that is scheduled in milliseconds."
  type        = string
  default     = "300000"
}

variable "path_cleanup_dry_run_enabled" {
  description = "Enable Path Cleanup to perform dry runs of deletions only."
  default     = "false"
  type        = string
}

variable "metadata_cleanup_dry_run_enabled" {
  description = "Enable Metadata Cleanup to perform dry runs of deletions only."
  default     = "false"
  type        = string
}

variable "api_dry_run_enabled" {
  description = "Enable API to perform dry runs of deletions only."
  default     = "false"
  type        = string
}

# Monitoring

variable "graphite_enabled" {
  description = "Enable to produce Graphite metrics - true or false."
  default     = "false"
  type        = string
}

variable "graphite_host" {
  description = "Graphite metrics host."
  default     = "localhost"
  type        = string
}

variable "graphite_prefix" {
  description = "Prefix for Graphite metrics."
  default     = ""
  type        = string
}

variable "graphite_port" {
  description = "Graphite port."
  default     = "2003"
  type        = string
}

variable "prometheus_enabled" {
  description = "Enable to pull metrics using Prometheus - true or false."
  default     = "false"
  type        = string
}

variable "metastore_uri" {
  description = "URI of the metastore where tables to be cleaned-up are located. Required for Beekeeper Metadata Cleanup"
  default     = ""
  type        = string
}

# K8S Configuration

variable "k8s_app_name" {
  description = "Name to give to all Kubernetes resources that are deployed."
  default     = ""
  type        = string
}

variable "k8s_kiam_role_arn" {
  description = "KIAM role arn to use for creating a K8S IAM role with the correct assume role permissions."
  default     = ""
  type        = string
}

variable "k8s_db_password_secret" {
  description = "Name of the Kubernetes secret that would store the db password for beekeeper."
  default     = "beekeeper-db-password"
  type        = string
}

variable "k8s_namespace" {
  description = "Namespace to deploy all Kubernetes resources to."
  default     = "beekeeper"
  type        = string
}

variable "k8s_image_pull_policy" {
  description = "Policy for the Kubernetes orchestrator to pull images."
  default     = "Always"
  type        = string
}

variable "k8s_node_affinity" {
  description = "Full node_affinity object as per terraform/Kubernetes docs."
  default     = {}
  type        = object({})
}

variable "k8s_node_selector" {
  description = "Full node_selector object as per terraform/Kubernetes docs."
  default     = {}
  type        = object({})
}

variable "k8s_node_tolerations" {
  description = "Full k8s_node_tolerations object as per terraform/Kubernetes docs."
  default     = {}
  type        = object({})
}

variable "k8s_ingress_enabled" {
  description = "Boolean flag to determine if we should create an ingress or not. (0 = off, 1 = on)."
  default     = 0
  type        = number
}

variable "k8s_ingress_tls_hosts" {
  description = "List of hosts for TLS configuration of a Kubernetes ingress."
  default     = []
  type        = list(string)
}

variable "k8s_ingress_tls_secret" {
  description = "Secret name for TLS configuration of a Kubernetes ingress."
  default     = ""
  type        = string
}

# K8S - path cleanup deployment

variable "k8s_path_cleanup_memory" {
  description = "Total memory to allot to the Beekeeper Path Cleanup pod."
  default     = "2Gi"
  type        = string
}

variable "k8s_path_cleanup_cpu" {
  description = "Total cpu to allot to the Beekeeper Path Cleanup pod."
  default     = "500m"
  type        = string
}

variable "k8s_path_cleanup_port" {
  description = "Internal port that the Beekeeper Path Cleanup service runs on."
  default     = 8008
  type        = number
}

variable "k8s_path_cleanup_liveness_delay" {
  description = "Liveness delay (in seconds) for the Beekeeper Path Cleanup service."
  default     = 60
  type        = number
}

variable "k8s_path_cleanup_ingress_host" {
  description = "Ingress host name for Beekeeper Path Cleanup."
  default     = ""
  type        = string
}

variable "k8s_path_cleanup_ingress_path" {
  description = "Ingress path regex for Beekeeper Path Cleanup."
  default     = ""
  type        = string
}

# K8S - metadata cleanup deployment

variable "k8s_metadata_cleanup_memory" {
  description = "Total memory to allot to the Beekeeper Metadata Cleanup pod."
  default     = "2Gi"
  type        = string
}

variable "k8s_metadata_cleanup_cpu" {
  description = "Total cpu to allot to the Beekeeper Metadata Cleanup pod."
  default     = "500m"
  type        = string
}

variable "k8s_metadata_cleanup_port" {
  description = "Internal port that the Beekeeper Metadata Cleanup service runs on."
  default     = 9008
  type        = number
}

variable "k8s_metadata_cleanup_liveness_delay" {
  description = "Liveness delay (in seconds) for the Beekeeper Metadata Cleanup service."
  default     = 60
  type        = number
}

variable "k8s_metadata_cleanup_ingress_host" {
  description = "Ingress host name for Beekeeper Metadata Cleanup."
  default     = ""
  type        = string
}

variable "k8s_metadata_cleanup_ingress_path" {
  description = "Ingress path regex for Beekeeper Metadata Cleanup."
  default     = ""
  type        = string
}

# K8S - API deployment

variable "k8s_api_memory" {
  description = "Total memory to allot to the Beekeeper API pod."
  default     = "2Gi"
  type        = string
}

variable "k8s_api_cpu" {
  description = "Total cpu to allot to the Beekeeper API pod."
  default     = "500m"
  type        = string
}

variable "k8s_beekeeper_api_port" {
  description = "Internal port that the Beekeeper API service runs on."
  default     = 7008
  type        = number
}

variable "k8s_api_liveness_delay" {
  description = "Liveness delay (in seconds) for the Beekeeper API service."
  default     = 60
  type        = number
}

variable "k8s_api_ingress_host" {
  description = "Ingress host name for Beekeeper API."
  default     = ""
  type        = string
}

variable "k8s_api_ingress_path" {
  description = "Ingress path regex for Beekeeper API."
  default     = ""
  type        = string
}

# K8S - Scheduler Apiary deployment

variable "k8s_scheduler_apiary_memory" {
  description = "Total memory to allot to the Beekeeper Scheduler Apiary pod."
  default     = "2Gi"
  type        = string
}

variable "k8s_scheduler_apiary_cpu" {
  description = "Total cpu to allot to the Beekeeper Scheduler Apiary pod."
  default     = "500m"
  type        = string
}

variable "k8s_scheduler_apiary_port" {
  description = "Internal port that the Beekeeper Scheduler Apiary service runs on."
  default     = 8080
  type        = number
}

variable "k8s_scheduler_apiary_liveness_delay" {
  description = "Liveness delay (in seconds) for the Beekeeper Scheduler Apiary service."
  default     = 60
  type        = number
}

variable "k8s_scheduler_apiary_ingress_host" {
  description = "Ingress host name for Beekeeper Scheduler Apiary."
  default     = ""
  type        = string
}

variable "k8s_scheduler_apiary_ingress_path" {
  description = "Ingress path regex for Beekeeper Scheduler Apiary."
  default     = ""
  type        = string
}

# Lambda slack notifier

variable "slack_lambda_enabled" {
  description = "Boolean flag to determine if Beekeeper should create a Slack notifying Lambda for the dead letter queue. (0 = off, 1 = on)."
  default     = 0
  type        = number
}

variable "slack_channel" {
  description = "Slack channel to which alerts about messages landing on the dead letter queue should be sent."
  default     = ""
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack URL to which alerts about messages landing on the dead letter queue should be sent."
  default     = ""
  type        = string
}
