# #Create GCS bucket for remote state
# resource "google_storage_bucket" "tf-bucket" {
#   project       = var.gcp_project
#   name          = var.bucket-name
#   location      = var.gcp_region
#   force_destroy = true
#   storage_class = var.storage-class
#   versioning {
#     enabled = true
#   }
# }

#######
#   The below lines of need to be commented out for the first Terraform apply
#   since the bucket will not exist.  Once the bucket is created
#   fill it in below and run Terraform init.
#######
terraform {
  backend "gcs" {
    bucket = "config-conector-sample-tfstate" ####Insert state bucket 
  }
}