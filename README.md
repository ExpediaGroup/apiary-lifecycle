# Overview
Terraform deployment scripts for [Beekeeper](https://github.com/ExpediaGroup/beekeeper).

Includes support for deploying Beekeeper on ECS and Kubernetes. Also includes deployment scripts for a Lambda which notifies Slack when Beekeeper's dead letter queue receives a message (this module is not required to run Beekeeper).

## Dependencies
A database password is defined in `aws-secrets-manager`. The terraform module will use that password for the database (see property `k8s_db_password_secret `).


## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |
| kubernetes | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allowed\_s3\_buckets | List of S3 Buckets to which Beekeeper will have read-write access. | `list(string)` | `[]` | no |
| apiary\_metastore\_listener\_arn | ARN of the Apiary Metastore Listener. | `string` | n/a | yes |
| aws\_region | AWS region to use for resources. | `string` | n/a | yes |
| beekeeper\_tags | A map of tags to apply to resources. | `map(string)` | n/a | yes |
| path\_cleanup\_docker\_image | Beekeeper Path Cleanup  docker image. | `string` | `"expediagroup/beekeeper-path-cleanup"` | no |
| path\_cleanup\_docker\_image\_version | Beekeeper Path Cleanup  docker image version. | `string` | `"latest"` | no |
| path\_cleanup\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Path Cleanup ECS task.<br>Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `2048` | no |
| path\_cleanup\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Path Cleanup container.<br>Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `4096` | no |
| metadata\_cleanup\_docker\_image | Beekeeper Metadata Cleanup  docker image. | `string` | `"expediagroup/beekeeper-metadata-cleanup"` | no |
| metadata\_cleanup\_docker\_image\_version | Beekeeper Metadata Cleanup  docker image version. | `string` | `"latest"` | no |
| db\_backup\_retention | The number of days to retain backups for the RDS Beekeeper DB. | `number` | `10` | no |
| db\_backup\_window | Preferred backup window for the RDS Beekeeper DB in UTC. | `string` | `"02:00-03:00"` | no |
| db\_maintenance\_window | Preferred maintenance window for the RDS Beekeeper DB in UTC. | `string` | `"wed:03:00-wed:04:00"` | no |
| db\_password\_key | Key to acquire the database password for the strategy specified. | `string` | n/a | yes |
| db\_username | Username for the master DB user. | `string` | `"beekeeper"` | no |
| docker\_registry\_auth\_secret\_name | Docker Registry authentication SecretManager secret name. | `string` | `""` | no |
| path\_cleanup\_dry\_run\_enabled | Enable Path Cleanup to perform dry runs of deletions only. | `string` | `"false"` | no |
| metadata\_cleanup\_dry\_run\_enabled | Enable Metadata Cleanup to perform dry runs of deletions only. | `string` | `"false"` | no |
| graphite\_enabled | Enable to produce Graphite metrics - true or false. | `string` | `"false"` | no |
| graphite\_host | Graphite metrics host. | `string` | `"localhost"` | no |
| graphite\_port | Graphite port. | `number` | `2003` | no |
| graphite\_prefix | Prefix for Graphite metrics. | `string` | `""` | no |
| metastore\_uri | URI of the metastore where tables to be cleaned-up are located. Required for Beekeeper Metadata Cleanup. | `string` | `""` | yes |
| instance\_name | Beekeeper instance name to identify resources in multi-instance deployments. | `string` | `""` | no |
| instance\_type | Service to run Beekeeper on. Supported services: `ecs` (default), `k8s`. Leaving this blank will still deploy auxiliary components (e.g. RDS, SQS etc.). | `string` | `"ecs"` | no |
| k8s\_app\_name | Name to give to all Kubernetes resources that are deployed. | `string` | `"beekeeper"` | no |
| k8s\_path\_cleanup\_cpu | Total cpu to allot to the Beekeeper Path Cleanup pod. | `string` | `"500m"` | no |
| k8s\_path\_cleanup\_ingress\_host | Ingress host name for Beekeeper Path Cleanup. | `string` | `""` | no |
| k8s\_path\_cleanup\_ingress\_path | Ingress path regex for Beekeeper Path Cleanup. | `string` | `""` | no |
| k8s\_path\_cleanup\_liveness\_delay | Liveness delay (in seconds) for the Beekeeper Path Cleanup service. | `number` | `60` | no |
| k8s\_path\_cleanup\_memory | Total memory to allot to the Beekeeper Path Cleanup pod. | `string` | `"2Gi"` | no |
| k8s\_path\_cleanup\_port | Internal port that the Beekeeper Path Cleanup service runs on. | `number` | `8008` | no |
| k8s\_metadata\_cleanup\_cpu | Total cpu to allot to the Beekeeper Metadata Cleanup pod. | `string` | `"500m"` | no |
| k8s\_metadata\_cleanup\_ingress\_host | Ingress host name for Beekeeper Metadata Cleanup. | `string` | `""` | no |
| k8s\_metadata\_cleanup\_ingress\_path | Ingress path regex for Beekeeper Metadata Cleanup. | `string` | `""` | no |
| k8s\_metadata\_cleanup\_liveness\_delay | Liveness delay (in seconds) for the Beekeeper Metadata Cleanup service. | `number` | `60` | no |
| k8s\_metadata\_cleanup\_memory | Total memory to allot to the Beekeeper Metadata Cleanup pod. | `string` | `"2Gi"` | no |
| k8s\_metadata\_cleanup\_port | Internal port that the Beekeeper Metadata Cleanup service runs on. | `number` | `9008` | no |
| k8s\_image\_pull\_policy | Policy for the Kubernetes orchestrator to pull images. | `string` | `"Always"` | no |
| k8s\_ingress\_enabled | Boolean flag to determine if we should create an ingress or not. (0 = off, 1 = on). | `number` | `0` | no |
| k8s\_ingress\_tls\_hosts | List of hosts for TLS configuration of a Kubernetes ingress. | `list(string)` | `[]` | no |
| k8s\_ingress\_tls\_secret | Secret name for TLS configuration of a Kubernetes ingress. | `string` | `""` | no |
| k8s\_kiam\_role\_arn | KIAM role arn to use for creating a K8S IAM role with the correct assume role permissions. | `string` | `""` | no |
| k8s\_db\_password\_secret | Name of the Kubernetes secret that would store the db password for beekeeper. | `string` | `"beekeeper-db-password"` | no |
| k8s\_namespace | Namespace to deploy all Kubernetes resources to. | `string` | `"beekeeper"` | no |
| k8s\_node\_affinity | Full node\_affinity object as per terraform/Kubernetes docs. | `object({})` | `{}` | no |
| k8s\_node\_selector | Full node\_selector object as per terraform/Kubernetes docs. | `object({})` | `{}` | no |
| k8s\_node\_tolerations | Full k8s\_node\_tolerations object as per terraform/Kubernetes docs. | `object({})` | `{}` | no |
| k8s\_scheduler\_apiary\_cpu | Total cpu to allot to the Beekeeper Scheduler Apiary pod. | `string` | `"500m"` | no |
| k8s\_scheduler\_apiary\_ingress\_host | Ingress host name for Beekeeper Scheduler Apiary. | `string` | `""` | no |
| k8s\_scheduler\_apiary\_ingress\_path | Ingress path regex for Beekeeper Scheduler Apiary. | `string` | `""` | no |
| k8s\_scheduler\_apiary\_liveness\_delay | Liveness delay (in seconds) for the Beekeeper Scheduling service. | `number` | `60` | no |
| k8s\_scheduler\_apiary\_memory | Total memory to allot to the Beekeeper Scheduler Apiary pod. | `string` | `"2Gi"` | no |
| k8s\_scheduler\_apiary\_port | Internal port that the Beekeeper Scheduler Apiary service runs on. | `number` | `8080` | no |
| message\_retention\_seconds | SQS message retention (s). | `number` | `604800` | no |
| scheduler\_apiary\_docker\_image | Beekeeper Scheduler Apiary image. | `string` | `"expediagroup/beekeeper-scheduler-apiary"` | no |
| scheduler\_apiary\_docker\_image\_version | Beekeeper Scheduler Apiary image version. | `string` | `"latest"` | no |
| scheduler\_apiary\_ecs\_cpu | The amount of CPU used to allocate for the Beekeeper Scheduler Apiary ECS task.<br>Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `2048` | no |
| scheduler\_apiary\_ecs\_memory | The amount of memory (in MiB) used to allocate for the Beekeeper Scheduler Apiary container.<br>Valid values: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `4096` | no |
| k8s\_api\_memory| Total memory to allot to the Beekeeper API pod | `string` | `"1Gi"` | no |
| k8s\_api\_cpu| Total cpu to allot to the Beekeeper API pod | `string` | `"500m"` | no |
| k8s\_beekeeper\_api\_port | Internal port that the Beekeeper API service runs on | `number` | `7008` | yes |
| k8s\_api\_liveness\_delay | Liveness delay (in seconds) for the Beekeeper API service | `number` | `60` | no |
| k8s\_api\_ingress\_host | Ingress host name for Beekeeper API | `string` | `""` | no |
| k8s\_api\_ingress\_path | Ingress path regex for Beekeeper API | `string` | `""` | no |
| api\_docker\_image | Beekeeper API image | `string` | `"expediagroup/beekeeper-api"` | yes |
| api\_docker\_image\_version | Beekeeper API docker image version| `string` | `"latest"` | no |
| prometheus\_enabled | Enable to pull metrics using Prometheus - true or false. | `string` | `"false"` | no |
| queue\_name | Beekeeper SQS Queue name. | `string` | `"apiary-beekeeper"` | no |
| queue\_stale\_messages\_timeout | Beekeeper SQS Queue Cloudwatch Alert timeout for messages older than this number of seconds. | `number` | `1209600` | no |
| rds\_allocated\_storage | RDS allocated storage in GBs. | `string` | `10` | no |
| rds\_engine\_version | RDS engine version. | `string` | `"8.0"` | no |
| rds\_instance\_class | RDS instance class. | `string` | `"db.t2.micro"` | no |
| rds\_max\_allocated\_storage | RDS max allocated storage (autoscaling) in GBs. | `string` | `100` | no |
| rds\_parameter\_group\_name | RDS parameter group. | `string` | `"default.mysql8.0"` | no |
| rds\_storage\_type | RDS storage type. | `string` | `"gp2"` | no |
| rds\_subnets | Subnets in which to provision Beekeeper RDS DB. | `list(string)` | n/a | yes |
| receive\_wait\_time\_seconds | SQS receive wait time (s). | `number` | `20` | no |
| scheduler\_apiary\_delay\_ms | Delay between each cleanup job that is scheduled in milliseconds. | `number` | `300000` | no |
| slack\_channel | Slack channel to which alerts about messages landing on the dead letter queue should be sent. | `string` | `""` | no |
| slack\_lambda\_enabled | Boolean flag to determine if Beekeeper should create a Slack notifying Lambda for the dead letter queue. (0 = off, 1 = on). | `number` | `0` | no |
| slack\_webhook\_url | Slack URL to which alerts about messages landing on the dead letter queue should be sent. | `string` | `""` | no |
| subnets | Subnets in which to install Beekeeper. | `list(string)` | n/a | yes |
| vpc\_id | VPC in which to install Beekeeper. | `string` | n/a | yes |

## Outputs

No output.

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
