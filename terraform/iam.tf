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

# " binding between the SA & the predefined Kubernetes service account that Config Connector runs"
resource "google_service_account_iam_binding" "workloadIdentityUser" {
  service_account_id = google_service_account.idp-robot.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/external-secrets]",
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/external-secrets-identity]"
  ]
}




# resource "google_service_account_iam_binding" "k8s" {
#   service_account_id = google_service_account.idp-robot.name
#   role               = "roles/iam.workloadIdentityUser"
#   members = local.members

# }

# resource "google_service_account_iam_binding" "app" {
#   service_account_id = "projects/motiion-dev/serviceAccounts/minikube-dev@motiion-dev.iam.gserviceaccount.com"
#   role               = "roles/iam.workloadIdentityUser"
#   members = local.app
# }

# resource "google_service_account_iam_binding" "appprod" {
#   service_account_id = "projects/motiion-core-prod/serviceAccounts/minikube-prod-services@motiion-core-prod.iam.gserviceaccount.com"
#   role               = "roles/iam.workloadIdentityUser"
#   members = local.appprod
# }


# container.clusters.get
# gcloud projects add-iam-policy-binding jvillarreal-sandbox     --member=user:joseph.villarreal@66degrees.com --role=roles/owner


# gcloud projects add-iam-policy-binding jvillarreal-sandbox     --member=user:joseph.villarreal@66degrees.com --role=roles/container.clusters.get



# gcloud projects add-iam-policy-binding jvillarreal-sandbox  --member=user:joseph.villarreal@66degrees.com --role=roles/iam.serviceAccountAdmin

# gcloud iam service-accounts add-iam-policy-binding     idp-robot@jvillarreal-sandbox.iam.gserviceaccount.com     --member="user:joseph.villarreal@66degrees.com"     --role="roles/iam.serviceAccountUser"

# gcloud projects get-iam-policy jvillarreal-sandbox  \
# --flatten="bindings[].members" \
# --format='table(bindings.role)' \
# --filter="bindings.members:idp-robot@jvillarreal-sandbox.iam.gserviceaccount.com"


# gcloud iam service-accounts add-iam-policy-binding     idp-robot@jvillarreal-sandbox.iam.gserviceaccount.com     --member="user:joseph.villarreal@66degrees.com"     --role="roles/compute.admin"


# gcloud iam service-accounts add-iam-policy-binding     idp-robot@jvillarreal-sandbox.iam.gserviceaccount.com     --member="serviceAccount:idp-robot@jvillarreal-sandbox.iam.gserviceaccount.com"     --role="roles/iam.serviceAccountAdmin"
