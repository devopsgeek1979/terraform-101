terraform {
  backend "s3" {
    bucket         = "REPLACE-YOUR-TFSTATE-BUCKET"
    key            = "compute/ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "REPLACE-YOUR-TFSTATE-LOCK-TABLE"
  }
}
