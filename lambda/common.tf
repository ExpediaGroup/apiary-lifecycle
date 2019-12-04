/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  instance_alias_0 =  var.instance_name == "" ? "beekeeper" : format("beekeeper-%s",var.instance_name)
  instance_alias = var.existing_instance_name != "" ? var.existing_instance_name : local.instance_alias_0
## to accommodate existing long db name eg. bdp-beekeeper-hcom-data-lab
}
