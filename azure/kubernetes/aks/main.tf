###############################################################################
# infra-azure-aks  |  main.tf
###############################################################################

resource "azurerm_resource_group" "this" {
  name     = "infra-azure-rg-aks-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                              = "infra-azure-aks-${var.environment}"
  location                          = azurerm_resource_group.this.location
  resource_group_name               = azurerm_resource_group.this.name
  dns_prefix                        = "infra-aks-${var.environment}"
  kubernetes_version                = var.kubernetes_version
  private_cluster_enabled           = true
  role_based_access_control_enabled = true

  default_node_pool {
    name                 = "system"
    node_count           = var.system_node_count
    vm_size              = var.system_node_vm_size
    os_disk_size_gb      = var.node_disk_size_gb
    vnet_subnet_id       = var.subnet_id
    enable_auto_scaling  = true
    min_count            = var.system_node_min
    max_count            = var.system_node_max
    type                 = "VirtualMachineScaleSets"
    only_critical_addons_enabled = true
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    load_balancer_sku  = "standard"
    outbound_type      = "userDefinedRouting"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = local.common_tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  enable_auto_scaling   = true
  min_count             = var.user_node_min
  max_count             = var.user_node_max
  vnet_subnet_id        = var.subnet_id
  os_disk_size_gb       = var.node_disk_size_gb
  tags                  = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "infra-azure-aks"
  }
}
