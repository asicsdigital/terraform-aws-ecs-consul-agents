output "iam_role_arn" {
  value = aws_iam_role.consul_task.arn
}

output "iam_role_name" {
  value = aws_iam_role.consul_task.name
}

#output "iam_instance_profile_arn" {
#  value = "${aws_iam_instance_profile.bastion.arn}"
#
