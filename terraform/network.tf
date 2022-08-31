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
    protocol = "all"
    ports    = []
  }
  target_tags = ["vpn"]
  # target_service_accounts = ["terraform-argocd@crisp-build.iam.gserviceaccount.com",]
}

# #Prod - Dev Network Peering
# resource "google_compute_network_peering" "peering1" {
#   name         = "build-cicd-peering"
#   network      = google_compute_network.vpc.self_link
#   peer_network = google_compute_network.vpc-dev.self_link
# }

# # Private DNS with forwarding
# resource "google_dns_managed_zone" "wg-fwd-dns-zone" {
#   name        = "e2etesting"
#   dns_name    = "motiion-argo.local."
#   description = "DNS forwarder for crisp-build-e2e-testing GKE cluster"

#   visibility = "private"
#   private_visibility_config {
#     networks {
#       network_url = google_compute_network.vpc-dev.id
#     }
#   }

#   forwarding_config {
#     target_name_servers {
#       forwarding_path = "private"
#       ipv4_address    = google_compute_address.internal_with_subnet_and_address.address
#     }
#   }
# }