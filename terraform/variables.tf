# This block of code defines a Terraform variable named "gcp_region" with a type of string. The description field provides information about the variable's purpose, which is to specify the Google Cloud Platform (GCP) region. The default value for this variable is set to "us-central1".
variable "gcp_region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}
variable "gcp_project" {
  type        = string
  description = "GCP project name"
  default     = "config-conector-sample"
}

variable "enabled_services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "gkehub.googleapis.com"
  ]
}
variable "config_management" {
  type = object({
    version = string
    policy_controller = object({
      enabled                    = bool
      audit_interval_seconds     = number
      exemptable_namespaces      = list(string)
      log_denies_enabled         = bool
      referential_rules_enabled  = bool
      template_library_installed = bool
      mutation_enabled           = bool
      monitoring = object({
        backends = list(string)
      })
    })
    config_sync = object({
      prevent_drift = bool
      source_format = string
      git = object({
        sync_repo      = string
        sync_rev       = string
        sync_wait_secs = string
        sync_branch    = string
        policy_dir     = string
        secret_type    = string
      })
    })
  })
  default = {
    version = "1.12.2"
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
      source_format = "unstructured"
      git = {
        sync_repo      = ""
        sync_rev       = ""
        sync_wait_secs = ""
        sync_branch    = ""
        policy_dir     = ""
        secret_type    = ""
      }
    }
  }
}
variable "aggregation_interval" {
  type    = string
  default = "INTERVAL_15_MIN"
}

variable "flow_sampling" {
  type    = number
  default = 0.5
}

variable "metadata" {
  type    = string
  default = "INCLUDE_ALL_METADATA"
}


variable "subnetwork_cidr" {
  type = string
}
variable "pod_cidr" {
  type = string
}
variable "services_cidr" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "max_cpu" {
  description = "The maximum CPU in Gbs for the cluster"
  type        = number
  default     = 40
}
variable "max_memory" {
  description = "The maximum memory for the cluster"
  type        = number
  default     = 96
}
variable "autoscale_min_node" {
  description = "The minimum number of worker nodes available per zone."
  type        = number
  default     = 1
}
variable "autoscale_max_node" {
  description = "The maximum number of worker nodes available per zone."
  type        = number
  default     = 5
}
variable "machine_type" {
  description = "The type of machine to run the node."
  type        = string
  default     = "e2-standard-8"
}
variable "bucket-name" {
  type        = string
  description = "The name of the Google Storage Bucket to create to hold TF state."
}
variable "storage-class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
  default     = "REGIONAL"
}