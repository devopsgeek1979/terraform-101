###############################################################################
# infra-gcp-vpc  |  main.tf
###############################################################################

resource "google_compute_network" "this" {
  name                    = "infra-gcp-vpc-${var.environment}"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

resource "google_compute_subnetwork" "private" {
  name                     = "infra-gcp-subnet-private-${var.environment}"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.this.id
  project                  = var.project_id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "this" {
  name    = "infra-gcp-router-${var.environment}"
  network = google_compute_network.this.id
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "this" {
  name                               = "infra-gcp-nat-${var.environment}"
  router                             = google_compute_router.this.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "deny_all_ingress" {
  name    = "infra-gcp-fw-deny-all-ingress-${var.environment}"
  network = google_compute_network.this.name
  project = var.project_id

  deny {
    protocol = "all"
  }
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = 65534
}
