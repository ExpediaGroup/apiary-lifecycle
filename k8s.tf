/**
 * Copyright (C) 2019-2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  labels = {
    "app.kubernetes.io/name"       = local.k8s_app_alias
    "app.kubernetes.io/instance"   = local.k8s_app_alias
    "app.kubernetes.io/managed-by" = local.k8s_app_alias
  }
}

