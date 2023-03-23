# Create the service account with display name
resource "google_service_account" "idp-robot" {
  account_id   = "devops-robot"
  display_name = "devops-robot"
}

# Bind the owner role to the service account
resource "google_project_iam_binding" "idp-robot" {
  project = var.gcp_project
  role    = "roles/owner"

  members = ["serviceAccount:${google_service_account.idp-robot.email}"]
}

# Bind workloadIdentityUser role to the Kubernetes service account
resource "google_service_account_iam_binding" "workload_identity_user" {
  service_account_id = google_service_account.idp-robot.id
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.gcp_project}.svc.id.goog[cnrm-system/cnrm-controller-manager]"]
  depends_on = [
    google_container_cluster.primary,
    google_project_iam_binding.idp-robot
  ]
}
