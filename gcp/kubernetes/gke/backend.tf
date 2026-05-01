terraform {
  backend "gcs" {
    bucket = "REPLACE-YOUR-TFSTATE-BUCKET"
    prefix = "kubernetes/gke"
  }
}
