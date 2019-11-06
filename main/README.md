# Overview
Terraform deployment scripts for [Beekeeper](https://github.com/ExpediaGroup/beekeeper).

## Dependencies
If the chosen `db_password_strategy` is `aws-secrets-manager`, this terraform module will not create the database password automatically. The secret will need to be created in Secrets Manager separately with the specified `db_password_key`.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | AWS region to use for resources. | string | n/a | yes |
| vpc\_id | VPC id in which to install Beekeeper. | string | n/a | yes |
| subnets | Subnets ids in which to install Beekeeper. | list | n/a | yes |
| instance\_name | Beekeeper instance name to identify resources in multi-instance deployments. | string | `` | no |
| rds\_subnets | RDS subnet group name. | string | `"beekeeper-subnet-group"` | no |
| rds\_engine\_version | RDS engine version. | string | `"8.0"` | no |
| rds\_instance\_class | RDS instance class. | string | `"db.t2.micro"` | no |
| rds\_storage\_type | RDS storage type. | string | `"gp2"` | no |
| rds\_allocated\_storage | RDS allocated storage in GBs. | string | `"10"` | no |
| rds\_max\_allocated\_storage | RDS allocated storage in GBs. Used in autoscaling | string | `"100"` | no |
| rds\_parameter\_group\_name | RDS parameter group name. | string | `"default.mysql8.0"` | no |
| db\_username | DB master user. | string | `"beekeeper"` | no |
| db\_password\_key | Key to acquire the database password for the strategy specified. | string | n/a | yes |
| db\_password\_strategy | Strategy to acquire the password for the RDS instance. Supported strategies: aws-secrets-manager. | string | `"aws-secrets-manager"` | no |
| db\_backup\_window | Backup window of the RDS instance. | string | `"02:00-03:00"` | no |
| db\_backup\_retention | Backup retention of the RDS instance. | string | `"10"` | no |
| db\_maintenance\_window | Maintenance window of the RDS instance. | string | `"wed:03:00-wed:04:00"` | no |
| path\_scheduler\_docker\_image | Beekeeper path-scheduler docker image. | string | `"expediagroup/beekeeper-path-scheduler-apiary"` | yes |
| path\_scheduler\_docker\_image\_version | Beekeeper path-scheduler docker image version. | string | n/a | yes |
| path\_scheduler\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Path Scheduler Apiary ECS task. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values. | string | `"2048"` | no |
| path\_scheduler\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Path Scheduler Apiary container. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values. | string | `"4096"` | no |
| cleanup\_docker\_image | Beekeeper cleanup docker image. | string | n/a | yes |
| cleanup\_docker\_image\_version | Beekeeper cleanup docker image version. | string | n/a | yes |
| cleanup\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Cleanup ECS task. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html). for valid values. | string | `"2048"` | no |
| cleanup\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Cleanup container. See [docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) for valid values.  | string | `"4096"` | no |
| docker\_registry\_auth\_secret\_name | Docker Registry authentication SecretManager secret name. | string | `` | no |
| queue\_name | Beekeeper SQS queue name. | string | `"apiary-beekeeper"` | no |
| apiary\_metastore\_listener\_arn | ARN of the Apiary Metastore Listener. | string | n/a | yes |
| receive\_wait\_time\_seconds | SQS receive wait time (s). | string | `"20"` | no |
| message\_retention\_seconds | SQS message retention (s). | string | `"604800"` | no |
| queue\_stale\_messages\_timeout | SQS Queue Cloudwatch Alert timeout for messages older than this number of seconds. | string | `"1209600"` | no |
| scheduler\_delay\_ms | Delay between each cleanup job that is scheduled in milliseconds. | string | `"300000"` | no |
| allowed\_s3\_buckets | List of S3 Buckets to which Beekeeper will have read-write access. eg. `["bucket-1", "bucket-2"]`. | list | `n/a` | yes |
| graphite\_enabled | Enable to produce Graphite metrics - true or false. | string | `"false"` | no |
| graphite\_host | Graphite metrics host. | string | n/a | yes |
| graphite\_port | Graphite port. | string | `"2003"` | no |
| graphite\_prefix | Prefix for Graphite metrics. | string | n/a | yes |
| beekeeper\_tags | A map of tags to apply to resources. | map | n/a | yes |
| dry\_run\_enabled | Enable to perform dry runs of deletions only. | string | `"false"` | no |

# Contact

## Mailing List
If you would like to ask any questions about or discuss Apiary please join our mailing list at
https://groups.google.com/forum/#!forum/apiary-user

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
