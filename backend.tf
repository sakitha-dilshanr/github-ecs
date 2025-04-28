terraform {
  backend "s3" {
    bucket         = "tf-test-bucket-dilshanr"
    key            = "ecs-tf/terraform.tfstate" # Or whatever path you want
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}