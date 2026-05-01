output "instance_names" {
  description = "GCE instance names"
  value       = google_compute_instance.this[*].name
}
output "instance_self_links" {
  description = "GCE instance self-links"
  value       = google_compute_instance.this[*].self_link
}
output "service_account_email" {
  description = "GCE service account email"
  value       = google_service_account.vm.email
}
