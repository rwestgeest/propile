terraform {
 backend "s3" {
 encrypt = true
 bucket = "propile-terraform-state"
 dynamodb_table = "propile-terraform-state-lock"
 region = "eu-central-1"
 key = "terraform/propile-terraform-state"
 }
}