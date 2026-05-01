variable "vsphere_server" {
  description = "vCenter Server FQDN or IP"
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
variable "esxi_host" {
  description = "ESXi host FQDN"
  type        = string
}
variable "dvs_name" {
  description = "Distributed Virtual Switch name"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "mgmt_vlan_id" {
  description = "VLAN ID for management port group"
  type        = number
  default     = 100
}
variable "workload_vlan_id" {
  description = "VLAN ID for workload port group"
  type        = number
  default     = 200
}
variable "storage_vlan_id" {
  description = "VLAN ID for storage port group"
  type        = number
  default     = 300
}
