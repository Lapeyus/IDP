# terraform import google_service_account.idp-robot projects/crisp-build/serviceAccounts/idp-robot@crisp-build.iam.gserviceaccount.com
resource "google_service_account" "idp-robot" {
  account_id   = "devops-robot"
  display_name = "devops-robot"
}

resource "google_project_iam_binding" "idp-robot" {
  project = var.gcp_project
  role    = "roles/owner"
  members = [
    "serviceAccount:${google_service_account.idp-robot.email}"
  ]
}

resource "google_folder_iam_binding" "folder" {
  folder  = "folders/302633594206"
  role    = "roles/resourcemanager.folderCreator"

  members = [
    "serviceAccount:${google_service_account.idp-robot.email}"
  ]
}
resource "google_folder_iam_binding" "project" {
  folder  = "folders/302633594206"
  role    = "roles/resourcemanager.projectCreator"

  members = [
    "serviceAccount:${google_service_account.idp-robot.email}"
  ]
}
# " binding between the SA & the predefined Kubernetes service account that Config Connector runs"
resource "google_service_account_iam_binding" "workloadIdentityUser" {
  service_account_id = google_service_account.idp-robot.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
    # "serviceAccount:${var.gcp_project}.svc.id.goog[default/external-secrets-identity]"
  ]
  depends_on = [
    google_container_cluster.primary,
    google_gke_hub_feature.feature,
    google_gke_hub_membership.membership,
    google_gke_hub_feature_membership.feature_member
  ]
}