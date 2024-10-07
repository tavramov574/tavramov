data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "myawesomeprojectbucket1205"
    key    = "networking.tf"
    region = "eu-west-1"
  }
}
