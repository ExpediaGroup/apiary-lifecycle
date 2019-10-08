# Global

variable "profile" {
  description = "AWS Profile to use."
  type        = "string"
}

variable "region" {
  description = "AWS Region name"
  default     = "us-west-2"
  type        = "string"
}

variable "account_id" {
  description = "AWS account id"
  type        = "string"
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = "map"
}

# Networking

variable "vpc-name" {
  description = "Name of the VPC in which to install Beekeeper."
  type        = "string"
}

variable "subnet-names" {
  description = "Names of the subnets in which to install Beekeeper."
  type        = "list"
}

variable "security-group-names" {
  description = "Names of the security groups in which to install Beekeeper ECS."
  type        = "list"
}

# RDS specific

variable "rds-subnet-group-name" {
  description = "RDS subnet group name."
  default     = "beekeeper-subnet-group"
  type        = "string"
}

variable "allocated-storage" {
  description = "RDS allocated storage."
  default     = 10
  type        = "string"
}

variable "storage-type" {
  description = "RDS storage type."
  default     = "gp2"
  type        = "string"
}

variable "instance-class" {
  description = "RDS instance class."
  default     = "db.t2.micro"
  type        = "string"
}

variable "engine-version" {
  description = "RDS engine version."
  default     = "8.0"
  type        = "string"
}

variable "parameter-group-name" {
  description = "RDS parameter group name."
  default     = "default.mysql8.0"
  type        = "string"
}

variable "username" {
  description = "RDS username."
  default     = "user"
  type        = "string"
}

variable "password" {
  description = "RDS password."
  type        = "string"
}

# SQS specific

variable "queue-name" {
  description = "Queue name."
  default     = "apiary-beekeeper"
  type        = "string"
}

variable "message-retention-seconds" {
  description = "SQS message retention (s)."
  default     = "604800"
  type        = "string"
}

variable "receive-wait-time-seconds" {
  description = "SQS receive wait time (s)."
  default     = "20"
  type        = "string"
}

variable "apiary-metastore-listener-arn" {
  description = "ARN of the Apiary Metastore Listener."
  type        = "string"
}

# ECS specific

variable "path-scheduler-apiary-docker-image-url" {
  description = "URL to the Beekeeper path-scheduler image."
  type        = "string"
}

variable "cleanup-docker-image-url" {
  description = "URL to the Beekeeper cleanup image."
  type        = "string"
}

variable "path-scheduler-apiary-memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Path Scheduler Apiary container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = "string"
}

variable "path-scheduler-apiary-cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Path Scheduler Apiary ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = "string"
}

variable "cleanup-memory" {
  description = <<EOF
The amount of memory (in MiB) used to allocate for the Beekeeper Cleanup container.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "4096"
  type    = "string"
}

variable "cleanup-cpu" {
  description = <<EOF
The amount of CPU used to allocate for the Beekeeper Cleanup ECS task.
Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
EOF

  default = "2048"
  type    = "string"
}

variable "graphite-enabled" {
  description = "Enable to produce Graphite metrics - true or false."
  default     = "false"
  type        = "string"
}

variable "graphite-host" {
  description = "Graphite metrics host."
  type        = "string"
}

variable "graphite-prefix" {
  description = "Prefix for Graphite metrics."
  type        = "string"
}

variable "graphite-port" {
  description = "Graphite port."
  default     = "2003"
  type        = "string"
}

variable "scheduler-delay-ms" {
  description = "Delay between each cleanup job that is scheduled in milliseconds."
  default     = "300000"
  type        = "string"
}

variable "dry-run-enabled" {
  description = "Enable to perform dry runs of deletions only."
  default     = "false"
  type        = "string"
}

variable "db-password-strategy" {
  description = "Strategy to acquire the password for the RDS instance. Supported strategies: aws-secrets-manager."
  default     = "aws-secrets-manager"
  type        = "string"
}

variable "db-password-key" {
  description = "Key to acquire the database password for the strategy specified."
  type        = "string"
}

variable "cleanup-buckets" {
  description = "Buckets which Beekeeper is allowed to do work in."
  type        = "string"
}
