variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "project" {
  description = "Project name"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID to deploy the EC2 instance into"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}
variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}
variable "root_volume_size_gb" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
variable "kms_key_arn" {
  description = "KMS key ARN for EBS encryption"
  type        = string
  default     = null
}
