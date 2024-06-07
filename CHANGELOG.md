# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [5.0.4] - 2024-06-05
### Changed
- Change kiam auth method to irsa for metadata cleanup, path cleanup and scheduler apiary

## [5.0.3] - 2024-05-14
### Changed
- Change provider version for kubernetes to 2.13.0 

## [5.0.2] - 2023-12-15
### Added
- Updating `beekeeper_slack_notifier`  Lambda function in `lambda.tf` that is currently using the deprecated Python 3.7 runtime to the Python 3.9 runtime

### Changed
- Updated hosted runner from the deprecated `ubuntu-18.04` to `ubuntu-22.04` to fix failing GitHub Actions

## [5.0.1] - 2023-12-05
### Added
- Added `HADOOP_USER_NAME` environment variable and set it to `beekeeper` 

## [5.0.0] - 2023-11-16
### Changed
- Upgdate k8s API to work with 2.x version:
  - `kubernetes_deployment` to `kubernetes_deployment_v1`
  - `kubernetes_ingress` to `kubernetes_ingress_v1`
- Update terrafrom `map` function to `tomap`(`map` function has been deprecated in `0.12` version).

## [4.0.1] - 2023-09-18
### Changed
- Increase k8s provider version to `~>2.7.0` (was `~>1.0.0`). Fixes issue with K8S upgrade and error: 'Failed to create Ingress'.

## [4.0.0] - 2023-03-14
### Added
- Added variables `db_apply_immediately`(default `false`) and `db_performance_insights_enabled` (default `true`).
- Minimum required version for `aws` provider set to `~> 4.0`.
### Changed
- Increased the required version of terraform to `>= 0.12.31` (was `> 0.12.0`).

## [3.3.0] - 2023-03-10 [YANKED]
### Changed
- Changed the `rds_storage_type` from `gp2` to `gp3`.
- Increased the `rds_allocated_storage` from 10 to 20 GB.

## [3.2.1] - 2021-08-27
### Added
- Changed the service namespace from `default` to `beekeeper` in `beekeeper-metadata-cleanup`, `beekeeper-path-cleanup` and `beekeeper-scheduler-apiary`.
- Changed some variables from type `string` to `number`.
- Fixed the `beekeeper` ingress so that the `k8s_ingress_enabled` variable works.

## [3.2.0] - 2021-08-13
### Added
- Terraform files for `beekeeper-api` module.

## [3.1.1] - 2021-04-06
### Changed
- Pin K8S provider version to `1.x` for compatibility with other Apiary components deployed in the same Terraform state file.
- Don't use instance alias as part of default DB name since all the Flyway scripts expect "beekeeper" as the db name.

## [3.1.0] - 2021-02-22
### Changed
- Removed variable `DB_PASSWORD_STRATEGY`.
- Securely injecting `db_password_key` in k8s and ecs instead of pulling these credentials from AWS Secret Manager in Beekeeper.

## [3.0.2] - 2021-02-01
### Added
- Added variable `docker_registry_secret_name` to pull docker images from a private registry.

## [3.0.1] - 2020-09-18
### Changed
- Separated `dry_run_enabled` variable into `path_cleanup_dry_run_enabled` and `metadata_cleanup_dry_run_enabled` so one module can be used in dry run mode without affecting the other.  

## [3.0.0] - 2020-09-11
### Added
- Kubernetes deployment options for new Metadata Cleanup module. 
### Changed
- Renamed `Cleanup` to `Path Cleanup`, and `Path Scheduler` to `Scheduler Apiary` to match name changes in Beekeeper.

## [2.1.3] - 2020-08-07
### Changed
- Fix multi instance deployment resource names.

## [2.1.2] - 2020-07-01
### Added
- Default blank value for `k8s_kiam_role_arn`.

## [2.1.1] - 2020-06-24
### Added
- Refactoring graphite configuration so that it can be switched off.

## [2.1.0] - 2020-02-12
### Added
- Add annotations to Kubernetes deployments to support Prometheus scraper.

## [2.0.0] - 2020-01-28
### Added
- Add support for Kubernetes by specifying `var.instance_type = "k8s"`.
- Add Kubernetes deployment options for Cleanup and Path Scheduler.
- Add KIAM role creation for k8s pods.

### Changed
- Refactored to remove `main` and `lambda` modules.
- Updated Terraform syntax to be compliant with Terraform 0.12 and not throw warnings.
- Run `terraform fmt` on all code to enforce style.

## [1.1.0] - 2020-01-13
### Added
- Updating S3 IAM policy name to be region specific.

## [1.0.0] - 2019-12-10
### Added
- First version of Beekeeper terraform module
