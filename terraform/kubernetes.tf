# terraform import kubernetes_manifest.connector_config "apiVersion=core.cnrm.cloud.google.com/v1beta1,kind=ConfigConnector,namespace=default,name=configconnector.core.cnrm.cloud.google.com"
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
  ]

  for_each = toset(["default", "config-management-system"])
}

