output "namespace_name" {
  description = "TKGs Supervisor Namespace name"
  value       = vsphere_namespace.this.name
}
output "supervisor_id" {
  description = "Supervisor resource ID"
  value       = vsphere_supervisor.this.id
}
