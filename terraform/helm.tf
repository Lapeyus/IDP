provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.template_file.access_token.rendered
  }
}

#  argo helm chart.
resource "helm_release" "argo" {
  atomic                     = false
  chart                      = "argo-cd"
  cleanup_on_fail            = false
  create_namespace           = true
  dependency_update          = false
  disable_crd_hooks          = false
  disable_openapi_validation = false
  disable_webhooks           = false
  force_update               = true
  lint                       = false
  max_history                = 0
  name                       = "argo-cd"
  namespace                  = "default"
  pass_credentials           = false
  recreate_pods              = false
  render_subchart_notes      = true
  replace                    = false
  repository                 = "https://argoproj.github.io/argo-helm"
  reset_values               = false
  reuse_values               = false
  skip_crds                  = false
  timeout                    = 300
  verify                     = false
  version                    = "5.13.8"
  wait                       = true
  wait_for_jobs              = false
  depends_on = [
    google_container_cluster.primary
  ]
}