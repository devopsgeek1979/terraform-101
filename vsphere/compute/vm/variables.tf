variable "vsphere_server" {
  description = "vCenter FQDN or IP"
  type        = string
}
variable "vsphere_user" {
  description = "vCenter username"
  type        = string
}
variable "vsphere_password" {
  description = "vCenter password"
  type        = string
  sensitive   = true
}
variable "datacenter" {
  description = "vSphere Datacenter name"
  type        = string
}
variable "datastore" {
  description = "Datastore name"
  type        = string
}
variable "cluster" {
  description = "Compute cluster name"
  type        = string
}
variable "port_group_name" {
  description = "Port group / network name"
  type        = string
}
variable "template_name" {
  description = "VM template name to clone from"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "domain" {
  description = "DNS domain suffix"
  type        = string
  default     = "local"
}
variable "instance_count" {
  description = "Number of VMs to provision"
  type        = number
  default     = 1
}
variable "num_cpus" {
  description = "Number of vCPUs per VM"
  type        = number
  default     = 4
}
variable "memory_mb" {
  description = "Memory per VM in MB"
  type        = number
  default     = 8192
}
variable "disk_size_gb" {
  description = "Primary disk size in GB"
  type        = number
  default     = 80
}
