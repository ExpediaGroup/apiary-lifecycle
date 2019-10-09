# Overview
Terraform deployment scripts for [Beekeeper](https://github.com/ExpediaGroup/beekeeper).

## Dependencies
If the chosen `db-password-strategy` is `aws-secrets-manager`, this terraform module will not create the database password automatically. The secret will need to be created in Secrets Manager separately with the specified `db-password-key`.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allocated-storage | RDS allocated storage. | string | `"10"` | no |
| apiary-metastore-listener-arn | ARN of the Apiary Metastore Listener. | string | n/a | yes |
| cleanup-cpu | The amount of CPU used to allocate for the Beekeeper Cleanup ECS task. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html). for valid values. | string | `"2048"` | no |
| cleanup-docker-image-url | URL to the Beekeeper cleanup image. | string | n/a | yes |
| cleanup-memory | The amount of memory (in MiB) used to allocate for the Beekeeper Cleanup container. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values.  | string | `"4096"` | no |
| db-password-key | Key to acquire the database password for the strategy specified. | string | n/a | yes |
| db-password-strategy | Strategy to acquire the password for the RDS instance. Supported strategies: aws-secrets-manager. | string | `"aws-secrets-manager"` | no |
| dry-run-enabled | Enable to perform dry runs of deletions only. | string | `"false"` | no |
| engine-version | RDS engine version. | string | `"8.0"` | no |
| graphite-enabled | Enable to produce Graphite metrics - true or false. | string | `"false"` | no |
| graphite-host | Graphite metrics host. | string | n/a | yes |
| graphite-port | Graphite port. | string | `"2003"` | no |
| graphite-prefix | Prefix for Graphite metrics. | string | n/a | yes |
| instance-class | RDS instance class. | string | `"db.t2.micro"` | no |
| message-retention-seconds | SQS message retention (s). | string | `"604800"` | no |
| parameter-group-name | RDS parameter group name. | string | `"default.mysql8.0"` | no |
| path-scheduler-apiary-cpu | The amount of CPU used to allocate for the Beekeeper Path Scheduler Apiary ECS task. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values. | string | `"2048"` | no |
| path-scheduler-apiary-docker-image-url | URL to the Beekeeper path-scheduler image. | string | n/a | yes |
| path-scheduler-apiary-memory | The amount of memory (in MiB) used to allocate for the Beekeeper Path Scheduler Apiary container. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values. | string | `"4096"` | no |
| profile | AWS Profile to use. | string | n/a | yes |
| queue-name | Queue name. | string | `"apiary-beekeeper"` | no |
| receive-wait-time-seconds | SQS receive wait time (s). | string | `"20"` | no |
| region | AWS Region name | string | `"us-west-2"` | no |
| scheduler-delay-ms | Delay between each cleanup job that is scheduled in milliseconds. | string | `"300000"` | no |
| security-group-names | Names of the security groups in which to install Beekeeper ECS. | list | n/a | yes |
| storage-type | RDS storage type. | string | `"gp2"` | no |
| subnet-group-name | RDS subnet group name. | string | `"beekeeper-subnet-group"` | no |
| subnet-names | Names of the subnets in which to install Beekeeper. | list | n/a | yes |
| tags | A map of tags to apply to resources. | map | n/a | yes |
| username | RDS username. | string | `"user"` | no |
| vpc-name | Name of the VPC in which to install Beekeeper. | string | n/a | yes |

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
