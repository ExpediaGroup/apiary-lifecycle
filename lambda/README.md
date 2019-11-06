# Overview
Terraform deployment scripts for a Lambda which notifies Slack when Beekeeper's dead letter queue receives a message. This module is not required to run Beekeeper.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance\_name | Beekeeper instance name to identify resources in multi-instance deployments. | string | `` | no |
| subnets | Subnets ids in which Beekeeper Lambda Slack notifier will have access to. | list | n/a | yes |
| security\_groups | Security groups to assign to the ENI of Beekeeper Lambda Slack notifier. | list | n/a | yes |
| queue\_name | Name of the Beekeeper Apiary listener queue. | string | `"apiary-beekeeper"` | no |
| slack\_channel | Slack channel to which alerts about messages landing on the dead letter queue should be sent. | string | n/a | yes |
| slack\_webhook\_url | Slack URL to which alerts about messages landing on the dead letter queue should be sent. | string | n/a | yes |
| beekeeper\_tags | A map of tags to apply to resources. | map | n/a | yes |

# Contact

## Mailing List
If you would like to ask any questions about or discuss Apiary please join our mailing list at

  [https://groups.google.com/forum/#!forum/apiary-user](https://groups.google.com/forum/#!forum/apiary-user)

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
