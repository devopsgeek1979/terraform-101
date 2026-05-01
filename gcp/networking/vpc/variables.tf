variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  type        = string
  default     = "10.2.0.0/20"
}

variable "project" {
  description = "Project label for tagging"
  type        = string
  default     = ""
}
