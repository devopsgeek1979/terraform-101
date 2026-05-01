output "vm_id" { value = azurerm_linux_virtual_machine.this.id }
output "vm_private_ip" { value = azurerm_network_interface.this.private_ip_address }
output "vm_identity_principal_id" { value = azurerm_linux_virtual_machine.this.identity[0].principal_id }
output "resource_group_name" { value = azurerm_resource_group.this.name }
