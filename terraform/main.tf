#Enable Cloud Resource Manager
resource "google_project_service" "gcp_resource_manager_api" {
  project                    = var.gcp_project
  for_each                   = toset(["compute.googleapis.com", "container.googleapis.com", "cloudresourcemanager.googleapis.com"])
  service                    = each.key
  disable_dependent_services = true
}

# #Sleep for 2m to allow for enablement before proceeding
# resource "time_sleep" "gcp_wait_crm_api_enabling" {
#   depends_on = [
#     google_project_service.gcp_resource_manager_api
#   ]
#   create_duration = "2m"
# }
resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"
  labels = {
    label = "my-label"
  }
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id

  secret_data = "secret-data"
}
