variable "project" {
  type = string
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
variable "location" {
  type    = string
  default = "eastus"
}
variable "vnet_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.1.1.0/24"
}
variable "private_subnet_cidr" {
  type    = string
  default = "10.1.11.0/24"
}
