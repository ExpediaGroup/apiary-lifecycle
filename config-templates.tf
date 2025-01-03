/**
 * Copyright (C) 2019-2021 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

data "template_file" "beekeeper_graphite_config" {
  template = file("${path.module}/files/beekeeper-graphite-config-segment.json")

  vars = {
    graphite_enabled = var.graphite_enabled
    graphite_host    = var.graphite_host
    graphite_prefix  = var.graphite_prefix
    graphite_port    = var.graphite_port
  }
}

data "template_file" "beekeeper_scheduler_apiary_config" {
  template = file("${path.module}/files/beekeeper-scheduler-apiary-config.json")

  vars = {
    db_endpoint     = var.beekeeper_db_external_hostname == "" ? aws_db_instance.beekeeper[0].endpoint : "${var.beekeeper_db_external_hostname}:${var.beekeeper_db_port}"
    db_name         = var.beekeeper_db_name
    db_username     = var.db_username
    queue           = aws_sqs_queue.beekeeper.id
    metastore_uri   = var.metastore_uri
    graphite_config = var.graphite_enabled == "false" ? "" : data.template_file.beekeeper_graphite_config.rendered
  }
}

data "template_file" "beekeeper_path_cleanup_config" {
  template = file("${path.module}/files/beekeeper-path-cleanup-config.json")

  vars = {
    db_endpoint        = var.beekeeper_db_external_hostname == "" ? aws_db_instance.beekeeper[0].endpoint : "${var.beekeeper_db_external_hostname}:${var.beekeeper_db_port}"
    db_name            = var.beekeeper_db_name
    db_username        = var.db_username
    scheduler_delay_ms = var.scheduler_delay_ms
    dry_run_enabled    = var.path_cleanup_dry_run_enabled
    graphite_config    = var.graphite_enabled == "false" ? "" : data.template_file.beekeeper_graphite_config.rendered
  }
}

data "template_file" "beekeeper_metadata_cleanup_config" {
  template = file("${path.module}/files/beekeeper-metadata-cleanup-config.json")

  vars = {
    db_endpoint        = var.beekeeper_db_external_hostname == "" ? aws_db_instance.beekeeper[0].endpoint : "${var.beekeeper_db_external_hostname}:${var.beekeeper_db_port}"
    db_name            = var.beekeeper_db_name
    db_username        = var.db_username
    scheduler_delay_ms = var.scheduler_delay_ms
    dry_run_enabled    = var.metadata_cleanup_dry_run_enabled
    metastore_uri      = var.metastore_uri
    graphite_config    = var.graphite_enabled == "false" ? "" : data.template_file.beekeeper_graphite_config.rendered
  }
}

data "template_file" "beekeeper_api_config" {
  template = file("${path.module}/files/beekeeper-api-config.json")

  vars = {
    db_endpoint        = var.beekeeper_db_external_hostname == "" ? aws_db_instance.beekeeper[0].endpoint : "${var.beekeeper_db_external_hostname}:${var.beekeeper_db_port}"
    db_name            = var.beekeeper_db_name
    db_username        = var.db_username
    scheduler_delay_ms = var.scheduler_delay_ms
    metastore_uri      = var.metastore_uri
    graphite_config    = var.graphite_enabled == "false" ? "" : data.template_file.beekeeper_graphite_config.rendered
  }
}

