output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.this.name
}
output "cluster_endpoint" {
  description = "GKE cluster private endpoint"
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}
output "cluster_ca_certificate" {
  value     = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive = true
}
output "node_service_account_email" {
  description = "GKE node pool service account email"
  value       = google_service_account.gke.email
}
