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

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = "map"
}

# Lambda

variable "slack-channel" {
  description = "Slack channel to which alerts about messages landing on the dead letter queue should be sent."
  type        = "string"
}

variable "slack-webhook-url" {
  description = "Slack URL to which alerts about messages landing on the dead letter queue should be sent."
  type        = "string"
}

variable "queue-name" {
  description = "Name of the Beekeeper Apiary listener queue."
  default     = "beekeeper-apiary-listener"
  type        = "string"
}
