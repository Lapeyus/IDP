# # GKE cluster
resource "google_container_cluster" "primary" {
  provider                  = google-beta
  enable_kubernetes_alpha   = false
  enable_legacy_abac        = false
  enable_shielded_nodes     = false
  location                  = var.gcp_region
  logging_service           = "logging.googleapis.com/kubernetes"
  monitoring_service        = "monitoring.googleapis.com/kubernetes"
  name                      = var.cluster_name
  network                   = google_compute_network.vpc.name
  node_locations            = ["us-central1-a", "us-central1-b", "us-central1-f"]
  project                   = var.gcp_project
  remove_default_node_pool  = true
  subnetwork                = google_compute_subnetwork.gke.name
  initial_node_count        = 1
  default_max_pods_per_node = 110
  cluster_autoscaling {
    autoscaling_profile = "BALANCED"
    enabled             = false
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false
  }
  database_encryption {
    state = "DECRYPTED"
  }
  default_snat_status {
    disabled = false
  }
  addons_config {
    cloudrun_config {
      disabled = true
    }
    config_connector_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {
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

  notification_config {
    pubsub {
      enabled = false
    }
  }
  pod_security_policy_config {
    enabled = false
  }
  release_channel {
    channel = "REGULAR"
  }
  vertical_pod_autoscaling {
    enabled = true
  }
  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  project  = var.gcp_project
  name     = "${google_container_cluster.primary.name}-node-pool"
  location = var.gcp_region
  cluster  = google_container_cluster.primary.name
  autoscaling {
    min_node_count = var.autoscale_min_node
    max_node_count = var.autoscale_max_node
  }
  node_config {
    metadata = {
      disable-legacy-endpoints = "true"
    }
    preemptible = true
    tags        = ["${var.gcp_project}-gke", "default-idp"]
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
    # service_account = google_service_account.idp-robot.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write", 
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    machine_type = var.machine_type
  }
  depends_on = [
    google_container_cluster.primary
  ]
}

# # terraform import google_gke_hub_feature.feature projects/config-conector-sample/locations/global/features/configmanagement
resource "google_gke_hub_feature" "feature" {
  name     = "configmanagement"
  location = "global"
  provider = google-beta
  depends_on = [
    google_container_cluster.primary
  ]
}

resource "google_gke_hub_membership" "membership" {
  membership_id = var.cluster_name
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.primary.id}"
    }
  }
  provider = google-beta
  depends_on = [
    google_container_cluster.primary
  ]
}

resource "google_gke_hub_feature_membership" "feature_member" {
  location   = "global"
  feature    = google_gke_hub_feature.feature.name
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.12.2"
    policy_controller {
      enabled                    = false
      audit_interval_seconds     = 15
      exemptable_namespaces      = ["anthos-identity-service", "cnrm-system", "config-management-monitoring", "config-management-system", "configconnector-operator-system", "gatekeeper-system", "kube-node-lease", "kube-public", "kube-system", "resource-group-system"]
      log_denies_enabled         = true
      referential_rules_enabled  = true
      template_library_installed = true
      mutation_enabled           = true
      monitoring {
        backends = ["PROMETHEUS", "CLOUD_MONITORING"]
      }
    }

    config_sync {
      prevent_drift = true
      source_format = "unstructured" # hierarchy|unstructured

      git {
        sync_repo      = "git@github.com:Lapeyus/IDP.git"
        sync_rev       = "HEAD"
        sync_wait_secs = "15"
        sync_branch    = "main"
        policy_dir     = "configsync/"
        secret_type    = "ssh"
      }
    }
  }
  provider = google-beta
  depends_on = [
    google_container_cluster.primary
  ]
}