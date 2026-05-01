output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.this[*].id
}
output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.this.id
}
output "security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2.id
}
output "iam_role_arn" {
  description = "EC2 IAM Role ARN"
  value       = aws_iam_role.ec2.arn
}
