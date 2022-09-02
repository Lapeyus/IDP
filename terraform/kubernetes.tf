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
      # "mode" = "namespaced"
    }
  }
  field_manager {
    force_conflicts = true
  }
}

# note this requires the terraform to be run regularly
resource "time_rotating" "mykey_rotation" {
  rotation_days = 30
}
resource "google_service_account_key" "gcpsm-secret-key" {
  service_account_id = google_service_account.idp-robot.name
  keepers = {
    rotation_time = time_rotating.mykey_rotation.rotation_rfc3339
  }
}

resource "kubernetes_secret" "gcpsm-secret" {
  metadata {
    name      = "gcpsm-secret"
    namespace = "default"
  }
  data = {
    "secret-access-credentials" = base64decode(google_service_account_key.gcpsm-secret-key.private_key)
  }
}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.template_file.access_token.rendered
  }
}

# external-secrets helm chart.
resource "helm_release" "external-secrets" {
  atomic                     = false
  chart                      = "external-secrets"
  cleanup_on_fail            = false
  create_namespace           = true
  dependency_update          = false
  disable_crd_hooks          = false
  disable_openapi_validation = false
  disable_webhooks           = false
  force_update               = true
  lint                       = false
  max_history                = 0
  name                       = "external-secrets"
  namespace                  = "default"
  pass_credentials           = false
  recreate_pods              = false
  render_subchart_notes      = true
  replace                    = false
  repository                 = "https://charts.external-secrets.io"
  reset_values               = false
  reuse_values               = false
  skip_crds                  = false
  timeout                    = 300
  verify                     = false
  version                    = "0.5.9"
  wait                       = true
  wait_for_jobs              = false
  # values = [
  #   "${file("external-secrets-values.yaml")}"
  # ]
}


resource "helm_release" "helm-gcp-secrets" {
  chart     = "../helm/helm-gcp-secrets"
  name      = "helm-gcp-secrets"
  namespace = "default"
  # create_namespace = true
  # values = [
  #   templatefile("../helm/helm-gcp-secrets/values.yaml", {
  #     projectID  = var.gcp_project
  #   })
  # ]
}

#  argo helm chart.
resource "helm_release" "argo" {
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  name             = "argo-cd"
  namespace        = "default"
  force_update     = true
  create_namespace = true
  # values = [
  #   "${file("manifests/argo-values.yaml")}"
  # ]
}

resource "kubernetes_manifest" "serviceusage" {
  manifest = yamldecode(templatefile("manifests/serviceusage.tftpl",
    {
      project = var.gcp_project
    }
  ))

  depends_on = [
    google_container_cluster.primary
  ]
}
resource "kubernetes_manifest" "secretmanager" {
  manifest = yamldecode(templatefile("manifests/secretmanager.tftpl",
    {
      project = var.gcp_project
    }
  ))

  depends_on = [
    google_container_cluster.primary
  ]
}
