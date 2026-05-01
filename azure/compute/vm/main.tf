###############################################################################
# infra-azure-vm  |  main.tf
# Production VM: managed disk encrypted, private NIC, no public IP
###############################################################################

resource "azurerm_resource_group" "this" {
  name     = "infra-azure-rg-vm-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_network_interface" "this" {
  name                = "infra-azure-nic-vm-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = "infra-azure-vm-${var.environment}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.this.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb

    # Encryption at rest via platform-managed key (use disk_encryption_set_id for CMK)
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {}

  tags = local.common_tags
}

resource "azurerm_managed_disk" "data" {
  count                = var.data_disk_count
  name                 = "infra-azure-disk-data-${var.environment}-${count.index + 1}"
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
  tags                 = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  count              = var.data_disk_count
  managed_disk_id    = azurerm_managed_disk.data[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = count.index
  caching            = "ReadWrite"
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "infra-azure-vm"
  }
}
