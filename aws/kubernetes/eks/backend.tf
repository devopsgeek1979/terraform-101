terraform {
  backend "s3" {
    bucket         = "REPLACE-YOUR-TFSTATE-BUCKET"
    key            = "kubernetes/eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "REPLACE-YOUR-TFSTATE-LOCK-TABLE"
  }
}
