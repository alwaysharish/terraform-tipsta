terraform {
  backend "s3" {
    bucket  = "tipsta-terraform-state-bucket" # Replace with your actual S3 bucket name
    key     = "state/terraform.tfstate"
    region  = "us-east-1"                     # Replace with your bucket's region
    encrypt = true
  }
}
