terraform {
  backend "gcs" {
    bucket = "REPLACE-YOUR-TFSTATE-BUCKET"
    prefix = "networking/vpc"
  }
}
