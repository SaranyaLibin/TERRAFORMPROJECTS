terraform {
  backend "s3" {
    bucket = "testbucket4789" 
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
    //use_lockfile = true
    dynamodb_table = "test"
    encrypt = true
  }
}