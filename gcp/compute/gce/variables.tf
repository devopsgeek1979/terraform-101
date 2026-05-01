variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}
variable "zones" {
  description = "List of GCP zones to spread instances across"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}
variable "instance_count" {
  description = "Number of GCE instances"
  type        = number
  default     = 1
}
variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "n2-standard-2"
}
variable "boot_disk_image" {
  description = "Boot disk source image"
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
}
variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}
variable "kms_key_self_link" {
  description = "KMS key self-link for CMEK disk encryption"
  type        = string
  default     = null
}
variable "subnetwork_self_link" {
  description = "Subnetwork self-link for the NIC"
  type        = string
}
variable "project" {
  description = "Project label"
  type        = string
  default     = ""
}
