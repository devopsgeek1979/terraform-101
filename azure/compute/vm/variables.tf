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
  description = "Subnet resource ID"
  type        = string
}
variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_D2s_v3"
}
variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "azureuser"
}
variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
}
variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 64
}
variable "data_disk_count" {
  description = "Number of data disks to attach"
  type        = number
  default     = 1
}
variable "data_disk_size_gb" {
  description = "Each data disk size in GB"
  type        = number
  default     = 128
}
variable "image_publisher" {
  description = "Marketplace image publisher"
  type        = string
  default     = "Canonical"
}
variable "image_offer" {
  description = "Marketplace image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}
variable "image_sku" {
  description = "Marketplace image SKU"
  type        = string
  default     = "22_04-lts-gen2"
}
