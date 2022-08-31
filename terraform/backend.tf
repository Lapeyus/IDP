########
##   The below lines of need to be commented out for the first Terraform apply
##   since the bucket will not exist.  Once the bucket is created
##   fill it in below and run Terraform init.
########

terraform {
  backend "gcs" {
    bucket = "jvillarreal-sandbox-tfstate" ####Insert state bucket 

  }
}