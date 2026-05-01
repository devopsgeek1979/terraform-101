output "vnet_id" { value = azurerm_virtual_network.this.id }
output "vnet_name" { value = azurerm_virtual_network.this.name }
output "public_subnet_id" { value = azurerm_subnet.public.id }
output "private_subnet_id" { value = azurerm_subnet.private.id }
output "resource_group_name" { value = azurerm_resource_group.this.name }
output "nsg_private_id" { value = azurerm_network_security_group.private.id }
