###############################################################################
# infra-gcp-gke  |  main.tf
# Private GKE cluster: Workload Identity, CMEK, Shielded nodes, Binary Auth
###############################################################################

resource "google_service_account" "gke" {
  account_id   = "infra-gcp-sa-gke-${var.environment}"
  display_name = "GKE Node SA - ${var.environment}"
  project      = var.project_id
}

resource "google_project_iam_member" "gke_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_container_cluster" "this" {
  name       = "infra-gcp-gke-${var.environment}"
  location   = var.region
  project    = var.project_id
  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  # Remove default node pool; we manage it separately
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  binary_authorization { evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE" }

  release_channel { channel = "REGULAR" }

  master_auth {
    client_certificate_config { issue_client_certificate = false }
  }

  addons_config {
    http_load_balancing { disabled = false }
    horizontal_pod_autoscaling { disabled = false }
    dns_cache_config { enabled = true }
    gce_persistent_disk_csi_driver_config { enabled = true }
  }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = var.kms_key_self_link
  }

  logging_config { enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"] }
  monitoring_config { enable_components = ["SYSTEM_COMPONENTS"] }

  resource_labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_container_node_pool" "primary" {
  name       = "infra-gcp-gke-np-${var.environment}"
  cluster    = google_container_cluster.this.id
  location   = var.region
  project    = var.project_id
  node_count = var.node_count

  autoscaling {
    min_node_count = var.node_min_count
    max_node_count = var.node_max_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = var.machine_type
    service_account = google_service_account.gke.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    disk_size_gb    = var.node_disk_size_gb
    disk_type       = "pd-ssd"
    image_type      = "COS_CONTAINERD"

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config { mode = "GKE_METADATA" }
  }
}
