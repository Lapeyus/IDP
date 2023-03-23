terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.63.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "google-beta" {
  project = var.gcp_project
}

provider "google" {
  project = var.gcp_project
}

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

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.template_file.access_token.rendered
  }
}