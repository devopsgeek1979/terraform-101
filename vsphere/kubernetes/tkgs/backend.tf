terraform {
  backend "s3" {
    bucket  = "REPLACE-YOUR-TFSTATE-BUCKET"
    key     = "vsphere/kubernetes/tkgs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
