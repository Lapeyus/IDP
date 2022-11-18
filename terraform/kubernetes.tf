#Expose an access token for communicating with the GKE cluster.
data "google_client_config" "client" {}

#Create access token
data "template_file" "access_token" {
  template = data.google_client_config.client.access_token
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.template_file.access_token.rendered
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

# # terraform import kubernetes_manifest.connector_config "apiVersion=core.cnrm.cloud.google.com/v1beta1,kind=ConfigConnector,namespace=default,name=configconnector.core.cnrm.cloud.google.com"
resource "kubernetes_manifest" "connector_config" {
  manifest = {
    "apiVersion" = "core.cnrm.cloud.google.com/v1beta1"
    "kind"       = "ConfigConnector"
    "metadata" = {
      "name" = "configconnector.core.cnrm.cloud.google.com"
    }
    "spec" = {
      "googleServiceAccount" = "${google_service_account.idp-robot.email}"
      "mode"                 = "cluster"
    }
  }
  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_secret" "git-creds" {
  metadata {
    name      = "git-creds"
    namespace = each.key
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    "ssh"           = file("~/.ssh/id_rsa")
    "sshPrivateKey" = file("~/.ssh/id_rsa")
    "url"           = "git@github.com:Lapeyus/IDP.git"
  }
  depends_on = [
    google_container_cluster.primary,
    google_gke_hub_feature.feature,
    google_gke_hub_membership.membership,
    google_gke_hub_feature_membership.feature_member,
    google_service_account_iam_binding.workloadIdentityUser
  ]


  for_each = toset(["default", "config-management-system"])
}

