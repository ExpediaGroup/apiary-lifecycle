output "path_scheduler_config" {
  value       = "${data.template_file.beekeeper_path_scheduler_config.rendered}"
  description = "Rendered Spring config for Path Scheduler application."
}

output "cleanup_config" {
  value       = "${data.template_file.beekeeper_cleanup_config.rendered}"
  description = "Rendered Spring config for Cleanup application."
}

output "s3_policy_arn" {
  value       = "${aws_iam_policy.beekeeper_s3.arn}"
  description = "ARN for Path Scheduler IAM policy."
}

output "sqs_policy_arn" {
  value       = "${aws_iam_policy.beekeeper_sqs.arn}"
  description = "ARN for Cleanup IAM policy."
}

output "secrets_policy_arn" {
  value       = "${aws_iam_policy.beekeeper_secrets.arn}"
  description = "ARN for Cleanup IAM policy."
}

output "sg" {
  value       = "${aws_security_group.beekeeper_sg.id}"
  description = "ID of Beekeeper SG."
}
