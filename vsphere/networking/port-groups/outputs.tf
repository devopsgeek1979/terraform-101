output "mgmt_pg_id" { value = vsphere_distributed_port_group.management.id }
output "workload_pg_id" { value = vsphere_distributed_port_group.workload.id }
output "storage_pg_id" { value = vsphere_distributed_port_group.storage.id }
