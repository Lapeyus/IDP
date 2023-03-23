# GCP Settings
gcp_project = "config-conector-sample"
gcp_region  = "us-central1"

#Subnetwork CIDR ranges
subnetwork_cidr = "10.10.0.0/24"   #256
services_cidr   = "192.168.1.0/24" #256
pod_cidr        = "172.16.0.0/20"  #4,096

#Cluster 
cluster_name = "sauron"
max_cpu      = 40
max_memory   = 96

#Node
autoscale_min_node = 0
autoscale_max_node = 10
machine_type       = "e2-standard-8"

#Bucket Settings
bucket-name   = "config-conector-sample-tfstate"
storage-class = "REGIONAL"

config_management = {
  version = "1.14.1"
  policy_controller = {
    enabled                    = false
    audit_interval_seconds     = 15
    exemptable_namespaces      = ["anthos-identity-service", "cnrm-system", "config-management-monitoring", "config-management-system", "configconnector-operator-system", "gatekeeper-system", "kube-node-lease", "kube-public", "kube-system", "resource-group-system"]
    log_denies_enabled         = true
    referential_rules_enabled  = true
    template_library_installed = true
    mutation_enabled           = true
    monitoring = {
      backends = ["PROMETHEUS", "CLOUD_MONITORING"]
    }
  }
  config_sync = {
    prevent_drift = true
    source_format = "unstructured" # hierarchy|unstructured
    git = {
      sync_repo      = "git@github.com:Lapeyus/IDP.git"
      sync_rev       = "HEAD"
      sync_wait_secs = "15"
      sync_branch    = "main"
      policy_dir     = "configsync/"
      secret_type    = "ssh"
    }
  }
}