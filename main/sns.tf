/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_sns_topic" "beekeeper_ops_sns" {
  name = "${local.instance_alias}-operational-events"
}
