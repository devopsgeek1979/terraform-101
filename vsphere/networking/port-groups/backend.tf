terraform {
  backend "s3" {
    bucket  = "REPLACE-YOUR-TFSTATE-BUCKET"
    key     = "vsphere/networking/port-groups/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
