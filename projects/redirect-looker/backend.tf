terraform {
  backend "s3" {
    bucket = "cemd-terraform-states"
    #dynamodb_table = "terraform-state-lock-dynamo"
    key    = "utilities/redirect-looker/terraform.tfstate"
    region = "us-east-1"
  }
}