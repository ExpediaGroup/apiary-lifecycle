/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

variable "instance_name" {
  description = "Beekeeper instance name to identify resources in multi-instance deployments."
  type        = "string"
  default     = ""
}

variable "subnets" {
  description = "Subnets in which Lambda will have access to."
  type        = "list"
}

variable "security_groups" {
  description = "Security groups in which Lambda will have access to."
  type        = "list"
}

variable "slack_channel" {
  description = "Slack channel to which alerts about messages landing on the dead letter queue should be sent."
  type        = "string"
}

variable "slack_webhook_url" {
  description = "Slack URL to which alerts about messages landing on the dead letter queue should be sent."
  type        = "string"
}

variable "queue_name" {
  description = "Name of the Beekeeper Apiary listener queue."
  default     = "apiary-beekeeper"
  type        = "string"
}

variable "beekeeper_tags" {
  description = "A map of tags to apply to resources."
  type        = "map"
}
