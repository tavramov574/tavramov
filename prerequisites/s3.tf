resource "aws_s3_bucket" "terraform-bucket-tavramov" {
    bucket = "tsvetanavramovprojectbucket1205"
    #acl = "private"

    #versioning  {
        #enabled = true
    #}

    lifecycle  {
        prevent_destroy = false
    }

    tags = {
        Name = "Terraform File State Storage"
    }
}
