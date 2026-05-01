output "vpc_id" { value = google_compute_network.this.id }
output "vpc_self_link" { value = google_compute_network.this.self_link }
output "subnet_private_id" { value = google_compute_subnetwork.private.id }
output "nat_name" { value = google_compute_router_nat.this.name }
output "router_name" { value = google_compute_router.this.name }
