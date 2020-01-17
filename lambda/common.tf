/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  instance_alias = var.instance_name == "" ? "beekeeper" : format("beekeeper-%s", var.instance_name)
}
