# Overview
Terraform deployment scripts for a Lambda which notifies Slack when Beekeeper's dead letter queue receives a message. This module is not required to run Beekeeper.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| profile | AWS Profile to use. | string | n/a | yes |
| queue-name | Name of the Beekeeper Apiary listener queue. | string | `"apiary-beekeeper"` | no |
| region | AWS Region name | string | `"us-west-2"` | no |
| slack-channel | Slack channel to which alerts about messages landing on the dead letter queue should be sent. | string | n/a | yes |
| slack-webhook-url | Slack URL to which alerts about messages landing on the dead letter queue should be sent. | string | n/a | yes |
| tags | A map of tags to apply to resources. | map | n/a | yes |

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
