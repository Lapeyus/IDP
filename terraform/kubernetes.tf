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


  for_each = toset([ "default"])
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
  version                    = "4.9.10"
  wait                       = true
  wait_for_jobs              = false
  values = [
    "${file("manifests/argo-values.yaml")}"
  ]
  depends_on = [
    google_container_cluster.primary
  ]
}


resource "google_compute_address" "lb_ip_address" {
  provider     = google
  project      = var.gcp_project
  name         = "ingress-nginx"
  address_type = "EXTERNAL"
  region       = var.gcp_region
}

#  helm fetch ingress-nginx/ingress-nginx --untar --untardir helm/ --version 3.34.0 
# resource "helm_release" "ingress-nginx" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "kube-system"
#   version    = "3.34.0"
#   set {
#     name  = "controller.service.loadBalancerIP"
#     value = google_compute_address.lb_ip_address.address
#   }
#   set {
#     name  = "controller.service.annotations.service.kubernetes\\.io/ingress\\.global-static-ip-name"
#     value = google_compute_address.lb_ip_address.name
#   }
# }

# # note this requires the terraform to be run regularly
# resource "time_rotating" "mykey_rotation" {
#   rotation_days = 30
# }
# resource "google_service_account_key" "gcpsm-secret-key" {
#   service_account_id = google_service_account.idp-robot.name
#   keepers = {
#     rotation_time = time_rotating.mykey_rotation.rotation_rfc3339
#   }
# }

# resource "kubernetes_secret" "gcpsm-secret" {
#   metadata {
#     name      = "gcpsm-secret"
#     namespace = "default"
#   }
#   data = {
#     "secret-access-credentials" = base64decode(google_service_account_key.gcpsm-secret-key.private_key)
#   }
#   depends_on = [
#     google_container_cluster.primary
#   ]
# }

# # terraform import kubernetes_manifest.connector_config "apiVersion=core.cnrm.cloud.google.com/v1beta1,kind=ConfigConnector,namespace=default,name=configconnector.core.cnrm.cloud.google.com"
# resource "kubernetes_manifest" "connector_config" {
#   manifest = {
#     "apiVersion" = "core.cnrm.cloud.google.com/v1beta1"
#     "kind"       = "ConfigConnector"
#     "metadata" = {
#       "name" = "configconnector.core.cnrm.cloud.google.com"
#     }
#     "spec" = {
#       "googleServiceAccount" = "${google_service_account.idp-robot.email}"
#       "mode"                 = "cluster"
#       # "mode" = "namespaced"
#     }
#   }
#   field_manager {
#     force_conflicts = true
#   }
# }
# # external-secrets helm chart.
# resource "helm_release" "external-secrets" {
#   atomic                     = false
#   chart                      = "external-secrets"
#   cleanup_on_fail            = false
#   create_namespace           = true
#   dependency_update          = false
#   disable_crd_hooks          = false
#   disable_openapi_validation = false
#   disable_webhooks           = false
#   force_update               = true
#   lint                       = false
#   max_history                = 0
#   name                       = "external-secrets"
#   namespace                  = "default"
#   pass_credentials           = false
#   recreate_pods              = false
#   render_subchart_notes      = true
#   replace                    = false
#   repository                 = "https://charts.external-secrets.io"
#   reset_values               = false
#   reuse_values               = false
#   skip_crds                  = false
#   timeout                    = 300
#   verify                     = false
#   version                    = "0.5.9"
#   wait                       = true
#   wait_for_jobs              = false
#   # values = [
#   #   "${file("external-secrets-values.yaml")}"
#   # ]
# }


# resource "helm_release" "helm-gcp-secrets" {
#   chart     = "../helm/helm-gcp-secrets"
#   name      = "helm-gcp-secrets"
#   namespace = "default"
#   # create_namespace = true
#   # values = [
#   #   templatefile("../helm/helm-gcp-secrets/values.yaml", {
#   #     projectID  = var.gcp_project
#   #   })
#   # ]
# }

# resource "kubernetes_manifest" "serviceusage" {
#   manifest = yamldecode(templatefile("manifests/serviceusage.tftpl",
#     {
#       project = var.gcp_project
#     }
#   ))

#   depends_on = [
#     google_container_cluster.primary
#   ]
# }
# resource "kubernetes_manifest" "secretmanager" {
#   manifest = yamldecode(templatefile("manifests/secretmanager.tftpl",
#     {
#       project = var.gcp_project
#     }
#   ))

#   depends_on = [
#     google_container_cluster.primary
#   ]
# }
