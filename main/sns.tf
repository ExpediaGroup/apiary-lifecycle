/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_sns_topic" "beekeeper_ops_sns" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-operational-events"
}
