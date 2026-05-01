terraform {
  backend "s3" {
    bucket  = "REPLACE-YOUR-TFSTATE-BUCKET"
    key     = "vsphere/compute/vm/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
