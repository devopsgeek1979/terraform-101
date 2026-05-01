###############################################################################
# infra-aws-vpc  |  backend.tf  — PLACEHOLDER: update before first apply
###############################################################################

terraform {
  backend "s3" {
    bucket         = "REPLACE-YOUR-TFSTATE-BUCKET"
    key            = "networking/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "REPLACE-YOUR-TFSTATE-LOCK-TABLE"
  }
}
