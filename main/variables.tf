/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

# Global

variable "instance_name" {
  description = "Beekeeper instance name to identify resources in multi-instance deployments."
  type        = "string"
  default     = ""
}

variable "instance_type" {
  description = "Service to run Beekeeper on. Supported services: ecs (default). Override to deploy manually."
  type        = "string"
  default     = "ecs"
}

variable "aws_region" {
  description = "AWS region to use for resources."
  type        = "string"
}

variable "vpc_id" {
  description = "VPC in which to install Beekeeper."
  type        = "string"
}

variable "subnets" {
  description = "Subnets in which to install Beekeeper."
  type        = "list"
}

variable "beekeeper_tags" {
  description = "A map of tags to apply to resources."
  type        = "map"
}

# RDS specific

variable "rds_subnets" {
  description = "Subnets in which to provision Beekeeper RDS DB."
  type        = "list"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GBs."
  default     = 10
  type        = "string"
}

variable "rds_max_allocated_storage" {
  description = "RDS max allocated storage (autoscaling) in GBs."
  default     = 100
  type        = "string"
}

variable "rds_storage_type" {
  description = "RDS storage type."
  default     = "gp2"
  type        = "string"
}

variable "rds_instance_class" {
  description = "RDS instance class."
  default     = "db.t2.micro"
  type        = "string"
}

variable "rds_engine_version" {
  description = "RDS engine version."
  default     = "8.0"
  type        = "string"
}

variable "rds_parameter_group_name" {
  description = "RDS parameter group."
  default     = "default.mysql8.0"
  type        = "string"
}

variable "db_username" {
  description = "Username for the master DB user."
  default     = "beekeeper"
  type        = "string"
}

variable "db_password_strategy" {
  description = "Strategy to acquire the password for the RDS instance. Supported strategies: aws-secrets-manager."
  default     = "aws-secrets-manager"
  type        = "string"
}

variable "db_password_key" {
  description = "Key to acquire the database password for the strategy specified."
  type        = "string"
}

variable "db_backup_retention" {
  description = "The number of days to retain backups for the RDS Beekeeper DB."
  type        = "string"
  default     = 10
}

variable "db_backup_window" {
  description = "Preferred backup window for the RDS Beekeeper DB in UTC."
  type        = "string"
  default     = "02:00-03:00"
}

variable "db_maintenance_window" {
  description = "Preferred maintenance window for the RDS Beekeeper DB in UTC."
  type        = "string"
  default     = "wed:03:00-wed:04:00"
}

# SQS specific

variable "queue_name" {
  description = "Beekeeper SQS Queue name."
  type        = "string"
  default     = "apiary-beekeeper"
}

variable "message_retention_seconds" {
  description = "SQS message retention (s)."
  type        = "string"
  default     = "604800"
}

variable "receive_wait_time_seconds" {
  description = "SQS receive wait time (s)."
  type        = "string"
  default     = "20"
}

variable "apiary_metastore_listener_arn" {
  description = "ARN of the Apiary Metastore Listener."
  type        = "string"
}

variable "queue_stale_messages_timeout" {
  description = "Beekeeper SQS Queue Cloudwatch Alert timeout for messages older than this number of seconds."
  type        = "string"
  default     = "1209600"
}

# ECS specific

variable "path_scheduler_docker_image" {
  description = "Beekeeper path-scheduler image."
  type        = "string"
  default     = "expediagroup/beekeeper-path-scheduler-apiary"
}

variable "path_scheduler_docker_image_version" {
  description = "Beekeeper path-scheduler image version."
  type        = "string"
  default     = "latest"
}

variable "path_scheduler_ecs_cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Path Scheduler Apiary ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = "string"
}

variable "path_scheduler_ecs_memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Path Scheduler Apiary container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = "string"
}

variable "cleanup_docker_image" {
  description = "Beekeeper cleanup docker image."
  type        = "string"
  default     = "expediagroup/beekeeper-cleanup"
}

variable "cleanup_docker_image_version" {
  description = "Beekeeper cleanup docker image version."
  type        = "string"
  default     = "latest"
}

variable "cleanup_ecs_cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Cleanup ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = "string"
}

variable "cleanup_ecs_memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Cleanup container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = "string"
}

variable "docker_registry_auth_secret_name" {
  description = "Docker Registry authentication SecretManager secret name."
  type        = "string"
  default     = ""
}

# Application specific

variable "allowed_s3_buckets" {
  description = "List of S3 Buckets to which Beekeeper will have read-write access."
  type        = "list"
}

variable "scheduler_delay_ms" {
  description = "Delay between each cleanup job that is scheduled in milliseconds."
  type        = "string"
  default     = "300000"
}

variable "dry_run_enabled" {
  description = "Enable to perform dry runs of deletions only."
  default     = "false"
  type        = "string"
}

# Monitoring

variable "graphite_enabled" {
  description = "Enable to produce Graphite metrics - true or false."
  default     = "false"
  type        = "string"
}

variable "graphite_host" {
  description = "Graphite metrics host."
  type        = "string"
}

variable "graphite_prefix" {
  description = "Prefix for Graphite metrics."
  type        = "string"
}

variable "graphite_port" {
  description = "Graphite port."
  default     = "2003"
  type        = "string"
}
