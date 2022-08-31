# # GKE cluster
# resource "google_container_cluster" "argo" {
#   name     = "${var.project_id}-argo-cluster"
#   location = var.region
#   network    = google_compute_network.vpc.name
#   subnetwork = google_compute_subnetwork.gke.name
#   enable_autopilot = true
# }

resource "google_container_cluster" "primary" {
  provider                 = google-beta
  enable_kubernetes_alpha  = false
  enable_legacy_abac       = false
  enable_shielded_nodes    = false
  location                 = var.gcp_region
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  name                     = "argo" #"${var.gcp_project}"
  network                  = google_compute_network.vpc.name
  project                  = var.gcp_project
  remove_default_node_pool = true
  subnetwork               = google_compute_subnetwork.gke.name
  initial_node_count       = 1
  addons_config {
    cloudrun_config {
      disabled = true
    }
    config_connector_config {
      enabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = true
    }
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }
  identity_service_config {
    enabled = true
  }
  vertical_pod_autoscaling {
    enabled = true
  }
  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }
  # node_pool {
  #   initial_node_count = 1
  #   # instance_group_urls = (known after apply)
  #   # max_pods_per_node   = (known after apply)
  #   name = "default-idp"
  #   # name_prefix         = (known after apply)
  #   # node_count = 1
  #   # node_locations      = (known after apply)
  #   # version             = (known after apply)
  #   autoscaling {
  #     min_node_count = var.autoscale_min_node
  #     max_node_count = var.autoscale_max_node
  #   }
  #   management {
  #     auto_repair  = true
  #     auto_upgrade = true
  #   }
  #   node_config {
  #     # disk_size_gb      = (known after apply)
  #     # disk_type         = (known after apply)
  #     # guest_accelerator = (known after apply)
  #     # image_type        = (known after apply)
  #     # labels            = (known after apply)
  #     # local_ssd_count   = (known after apply)
  #     # machine_type      = (known after apply)
  #     metadata = {
  #       disable-legacy-endpoints = "true"
  #     } # min_cpu_platform  = (known after apply)
  #     # oauth_scopes      = (known after apply)
  #     preemptible     = true
  #     service_account = "idp-robot@crisp-343115.iam.gserviceaccount.com" #google_service_account.idp-robot.name
  #     tags            = ["${var.gcp_project}-gke", "default-idp"]
  #     # taint             = (known after apply)
  #     workload_metadata_config {
  #       mode = "GKE_METADATA"
  #       #node_metadata
  #     }
  #   }
  #   upgrade_settings {
  #     max_surge       = 1
  #     max_unavailable = 1
  #   }
  # }
  # vertical_pod_autoscaling {
  #   enabled = true
  # }
  # workload_identity_config {
  #   workload_pool = "${var.gcp_project}.svc.id.goog"
  # }
}

# # Separately Managed Node Pool
resource "google_container_node_pool" "primary_node" {
  project  = var.gcp_project
  name     = "${google_container_cluster.primary.name}-node-pool"
  location = var.gcp_region
  cluster  = google_container_cluster.primary.name
  # node_count = var.gke_num_nodes

  autoscaling {
    min_node_count = var.autoscale_min_node
    max_node_count = var.autoscale_max_node
  }
  node_config {
    metadata = {
      disable-legacy-endpoints = "true"
    }
    # min_cpu_platform  = (known after apply)
    # oauth_scopes      = (known after apply)
    preemptible = true
    tags        = ["${var.gcp_project}-gke", "default-idp"]
    # taint             = (known after apply)
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
      #node_metadata
    }
    service_account = google_service_account.idp-robot.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    machine_type = var.machine_type
  }

}
