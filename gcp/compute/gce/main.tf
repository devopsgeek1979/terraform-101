###############################################################################
# infra-gcp-gce  |  main.tf
###############################################################################

resource "google_service_account" "vm" {
  account_id   = "infra-gcp-sa-gce-${var.environment}"
  display_name = "GCE Service Account - ${var.environment}"
  project      = var.project_id
}

resource "google_compute_instance" "this" {
  count        = var.instance_count
  name         = "infra-gcp-gce-${var.environment}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zones[count.index % length(var.zones)]
  project      = var.project_id

  tags = ["infra-${var.environment}"]

  boot_disk {
    initialize_params {
      image  = var.boot_disk_image
      size   = var.boot_disk_size_gb
      type   = "pd-ssd"
    }
    kms_key_self_link = var.kms_key_self_link
  }

  network_interface {
    subnetwork = var.subnetwork_self_link
    # No access_config = no external IP (private only)
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata = {
    block-project-ssh-keys = "true"
    enable-oslogin         = "TRUE"
  }

  labels = {
    project     = var.project_id
    environment = var.environment
    managed_by  = "terraform"
  }
}
