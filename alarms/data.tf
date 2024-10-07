data "terraform_remote_state" "computing" {
  backend = "s3"
  config = {
    bucket = "myawesomeprojectbucket1205"
    key    = "computing.tf"
    region = "eu-west-1"
  }
}
