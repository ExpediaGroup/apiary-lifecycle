# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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
