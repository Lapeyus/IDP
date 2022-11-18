#Enable Cloud Resource Manager
resource "google_project_service" "gcp_resource_manager_api" {
  project = var.gcp_project
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "anthosconfigmanagement.googleapis.com" #*
  ])

  service                    = each.key
  disable_dependent_services = true
}

