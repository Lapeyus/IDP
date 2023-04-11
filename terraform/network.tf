# This resource block creates a VPC network for the IDP cluster
resource "google_compute_network" "vpc" {
  project                         = var.gcp_project       # The GCP project where the network will be created
  description                     = "VPC for IDP Cluster" # A description of the network
  name                            = "idp"                 # The name of the VPC network
  auto_create_subnetworks         = "false"               # Disables automatic subnetwork creation
  delete_default_routes_on_create = "false"               # Retains default routes when creating custom routes
  mtu                             = 1460                  # The maximum transmission unit (MTU) size for the network
  routing_mode                    = "REGIONAL"            # Specifies that the network is regional
}

# Define a subnetwork resource for GKE cluster
resource "google_compute_subnetwork" "gke" {
  name                       = "gke-subnet"
  region                     = var.gcp_region
  network                    = google_compute_network.vpc.name # Use the VPC network created earlier
  ip_cidr_range              = var.subnetwork_cidr             # Define IP range for the subnetwork
  private_ip_google_access   = true                            # Enable Private Google Access for instances in this subnet
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"         # Disable IPv6 Google access
  project                    = var.gcp_project

  # Define secondary IP ranges for pods and services
  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = var.pod_cidr
  }
  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = var.services_cidr
  }

  # Configure logging for the subnetwork
  log_config {
    aggregation_interval = var.aggregation_interval
    flow_sampling        = var.flow_sampling
    metadata             = var.metadata
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