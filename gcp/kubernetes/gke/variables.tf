variable "project_id" {
  description = "GCP project ID"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "region" {
  description = "GCP region for the cluster"
  type        = string
  default     = "us-central1"
}
variable "network_self_link" {
  description = "VPC network self-link"
  type        = string
}
variable "subnetwork_self_link" {
  description = "Subnetwork self-link"
  type        = string
}
variable "master_ipv4_cidr_block" {
  description = "CIDR for GKE master private endpoint"
  type        = string
  default     = "172.16.0.0/28"
}
variable "kms_key_self_link" {
  description = "KMS key self-link for etcd encryption"
  type        = string
}
variable "node_count" {
  description = "Initial nodes per zone"
  type        = number
  default     = 1
}
variable "node_min_count" {
  description = "Autoscaler min nodes per zone"
  type        = number
  default     = 1
}
variable "node_max_count" {
  description = "Autoscaler max nodes per zone"
  type        = number
  default     = 5
}
variable "machine_type" {
  description = "Node machine type"
  type        = string
  default     = "n2-standard-4"
}
variable "node_disk_size_gb" {
  description = "Node disk size in GB"
  type        = number
  default     = 100
}
variable "project" {
  description = "Project label"
  type        = string
  default     = ""
}
