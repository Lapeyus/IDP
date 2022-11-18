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