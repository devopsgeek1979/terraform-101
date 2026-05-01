variable "vsphere_server" {
  description = "vCenter Server FQDN"
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
variable "cluster" {
  description = "vSphere Compute Cluster name"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "storage_policy" {
  description = "VM Storage Policy name for TKGs"
  type        = string
}
variable "management_network" {
  description = "Management network name"
  type        = string
}
variable "mgmt_start_ip" {
  description = "Starting IP for management network"
  type        = string
}
variable "mgmt_subnet_mask" {
  description = "Management subnet mask"
  type        = string
}
variable "mgmt_gateway" {
  description = "Management gateway IP"
  type        = string
}
variable "dns_servers" {
  description = "DNS server IPs"
  type        = list(string)
}
variable "ingress_cidr" {
  description = "Ingress CIDR block"
  type        = string
  default     = "10.10.0.0/24"
}
variable "egress_cidr" {
  description = "Egress CIDR block"
  type        = string
  default     = "10.10.1.0/24"
}
variable "pod_cidr" {
  description = "Pod CIDR block"
  type        = string
  default     = "192.168.0.0/16"
}
variable "service_cidr" {
  description = "Service CIDR block"
  type        = string
  default     = "10.96.0.0/12"
}
variable "search_domains" {
  description = "DNS search domains"
  type        = list(string)
  default     = ["local"]
}
variable "namespace_subnet" {
  description = "CIDR for the supervisor namespace"
  type        = string
  default     = "10.10.2.0/24"
}
