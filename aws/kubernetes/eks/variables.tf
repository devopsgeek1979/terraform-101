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
  description = "VPC ID for the cluster"
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnet IDs for nodes and control plane ENIs"
  type        = list(string)
}
variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}
variable "kms_key_arn" {
  description = "KMS key ARN for secrets encryption and EBS"
  type        = string
}
variable "node_instance_types" {
  description = "EC2 instance types for managed node group"
  type        = list(string)
  default     = ["m6i.xlarge"]
}
variable "node_capacity_type" {
  description = "ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}
variable "node_desired_size" {
  description = "Desired node count"
  type        = number
  default     = 3
}
variable "node_min_size" {
  description = "Minimum node count"
  type        = number
  default     = 2
}
variable "node_max_size" {
  description = "Maximum node count"
  type        = number
  default     = 6
}
variable "node_disk_size_gb" {
  description = "Node root disk size in GB"
  type        = number
  default     = 100
}
