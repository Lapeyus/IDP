#Create new VPC for IDP Cluster 
resource "google_compute_network" "vpc" {
  project                         = var.gcp_project
  description                     = "VPC for IDP Cluster"
  name                            = "idp"
  auto_create_subnetworks         = "false"
  delete_default_routes_on_create = "false"
  mtu                             = 1460
  routing_mode                    = "REGIONAL"
}

#Create new subnet with two secondary ranges for pods and services
resource "google_compute_subnetwork" "gke" {
  name                     = "gke-subnet"
  region                   = var.gcp_region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = var.subnetwork_cidr
  private_ip_google_access = true
  project                  = var.gcp_project
  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = var.pod_cidr
  }
  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_compute_firewall" "gke-net-firewall" {
  project  = var.gcp_project
  name     = "gke-net-firewall"
  network  = google_compute_network.vpc.name
  priority = 1000
  allow {
    protocol = "UDP"
    ports    = [31899]
  }
  target_tags = ["default-idp"]
}