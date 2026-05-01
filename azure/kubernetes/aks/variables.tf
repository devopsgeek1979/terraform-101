variable "project" {
  description = "Project name"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}
variable "subnet_id" {
  description = "Subnet resource ID for AKS nodes"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.29"
}
variable "system_node_count" {
  description = "Initial system node pool count"
  type        = number
  default     = 3
}
variable "system_node_vm_size" {
  description = "System node pool VM size"
  type        = string
  default     = "Standard_D4s_v3"
}
variable "system_node_min" {
  description = "System pool autoscale min"
  type        = number
  default     = 2
}
variable "system_node_max" {
  description = "System pool autoscale max"
  type        = number
  default     = 5
}
variable "user_node_count" {
  description = "Initial user node pool count"
  type        = number
  default     = 3
}
variable "user_node_vm_size" {
  description = "User node pool VM size"
  type        = string
  default     = "Standard_D8s_v3"
}
variable "user_node_min" {
  description = "User pool autoscale min"
  type        = number
  default     = 2
}
variable "user_node_max" {
  description = "User pool autoscale max"
  type        = number
  default     = 10
}
variable "node_disk_size_gb" {
  description = "Node OS disk size in GB"
  type        = number
  default     = 100
}
variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID for OMS agent"
  type        = string
}
