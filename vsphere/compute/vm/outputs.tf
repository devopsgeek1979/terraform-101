output "vm_names" { value = vsphere_virtual_machine.this[*].name }
output "vm_ids" { value = vsphere_virtual_machine.this[*].id }
output "vm_default_ips" { value = vsphere_virtual_machine.this[*].default_ip_address }
