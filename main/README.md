# Overview
Terraform deployment scripts for [Beekeeper](https://github.com/ExpediaGroup/beekeeper).

## Dependencies
If the chosen `db_password_strategy` is `aws-secrets-manager`, this terraform module will not create the database password automatically. The secret will need to be created in Secrets Manager separately with the specified `db_password_key`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_s3\_buckets | List of S3 Buckets to which Beekeeper will have read-write access. | list | `<list>` | no |
| apiary\_metastore\_listener\_arn | ARN of the Apiary Metastore Listener. | string | n/a | yes |
| aws\_region | AWS region to use for resources. | string | n/a | yes |
| beekeeper\_tags | A map of tags to apply to resources. | map | n/a | yes |
| cleanup\_docker\_image | Beekeeper cleanup docker image. | string | `"expediagroup/beekeeper-cleanup"` | no |
| cleanup\_docker\_image\_version | Beekeeper cleanup docker image version. | string | `"latest"` | no |
| cleanup\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Cleanup ECS task. Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | string | `"2048"` | no |
| cleanup\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Cleanup container. Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | string | `"4096"` | no |
| db\_backup\_retention | The number of days to retain backups for the RDS Beekeeper DB. | string | `"10"` | no |
| db\_backup\_window | Preferred backup window for the RDS Beekeeper DB in UTC. | string | `"02:00-03:00"` | no |
| db\_maintenance\_window | Preferred maintenance window for the RDS Beekeeper DB in UTC. | string | `"wed:03:00-wed:04:00"` | no |
| db\_password\_key | Key to acquire the database password for the strategy specified. | string | n/a | yes |
| db\_password\_strategy | Strategy to acquire the password for the RDS instance. Supported strategies: aws-secrets-manager. | string | `"aws-secrets-manager"` | no |
| db\_username | Username for the master DB user. | string | `"beekeeper"` | no |
| docker\_registry\_auth\_secret\_name | Docker Registry authentication SecretManager secret name. | string | `""` | no |
| dry\_run\_enabled | Enable to perform dry runs of deletions only. | string | `"false"` | no |
| graphite\_enabled | Enable to produce Graphite metrics - true or false. | string | `"false"` | no |
| graphite\_host | Graphite metrics host. | string | n/a | yes |
| graphite\_port | Graphite port. | string | `"2003"` | no |
| graphite\_prefix | Prefix for Graphite metrics. | string | n/a | yes |
| instance\_name | Beekeeper instance name to identify resources in multi-instance deployments. | string | `""` | no |
| instance\_type | Service to run Beekeeper on. Supported services: `ecs` (default). Leaving this blank will deploy auxilliary components (e.g. RDS, SQS etc.) and will output IAM policies which can used to create the required roles. | string | `"ecs"` | no |
| message\_retention\_seconds | SQS message retention (s). | string | `"604800"` | no |
| path\_scheduler\_docker\_image | Beekeeper path-scheduler image. | string | `"expediagroup/beekeeper-path-scheduler-apiary"` | no |
| path\_scheduler\_docker\_image\_version | Beekeeper path-scheduler image version. | string | `"latest"` | no |
| path\_scheduler\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Path Scheduler Apiary ECS task. Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | string | `"2048"` | no |
| path\_scheduler\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Path Scheduler Apiary container. Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | string | `"4096"` | no |
| queue\_name | Beekeeper SQS Queue name. | string | `"apiary-beekeeper"` | no |
| queue\_stale\_messages\_timeout | Beekeeper SQS Queue Cloudwatch Alert timeout for messages older than this number of seconds. | string | `"1209600"` | no |
| rds\_allocated\_storage | RDS allocated storage in GBs. | string | `"10"` | no |
| rds\_engine\_version | RDS engine version. | string | `"8.0"` | no |
| rds\_instance\_class | RDS instance class. | string | `"db.t2.micro"` | no |
| rds\_max\_allocated\_storage | RDS max allocated storage (autoscaling) in GBs. | string | `"100"` | no |
| rds\_parameter\_group\_name | RDS parameter group. | string | `"default.mysql8.0"` | no |
| rds\_storage\_type | RDS storage type. | string | `"gp2"` | no |
| rds\_subnets | Subnets in which to provision Beekeeper RDS DB. | list | n/a | yes |
| receive\_wait\_time\_seconds | SQS receive wait time (s). | string | `"20"` | no |
| scheduler\_delay\_ms | Delay between each cleanup job that is scheduled in milliseconds. | string | `"300000"` | no |
| subnets | Subnets in which to install Beekeeper. | list | n/a | yes |
| vpc\_id | VPC in which to install Beekeeper. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| beekeeper\_cleanup\_config | Rendered Spring config for Cleanup application. |
| beekeeper\_path\_scheduler\_config | Rendered Spring config for Path Scheduler application. |
| s3\_policy\_arn | ARN for Path Scheduler IAM policy. |
| secrets\_policy\_arn | ARN for Cleanup IAM policy. |
| sqs\_policy\_arn | ARN for Cleanup IAM policy. |

# Contact

## Mailing List
If you would like to ask any questions about or discuss Apiary please join our mailing list at


# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
