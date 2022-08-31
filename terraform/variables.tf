variable "gcp_region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}
variable "gcp_project" {
  type        = string
  description = "GCP project name"
  default     = "jvillarreal-sandbox-360616"
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
variable "gke_username" {
  type        = string
  description = "GKE username"
  default     = ""
}
variable "gke_password" {
  type        = string
  description = "GKE password"
  default     = ""
}
variable "cluster" {
  type        = string
  description = "The name of the cluster where ArgoCD will reside."
}
variable "gke_num_nodes" {
  type        = number
  default     = 1
  description = "number of gke nodes"
}

variable "service_account" {
  type = string
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
# variable "user_names" {
#   description = "Create IAM users with these names"
#   type        = list(string)
#   default     = [
#     "jvillarreal",
#     "default",
#   ]
# }

# locals {
#   members = "${formatlist("serviceAccount:${var.gcp_project}.svc.id.goog[%s/%s-job]", var.user_names,var.user_names)}"
#   app = "${formatlist("serviceAccount:${var.gcp_project}.svc.id.goog[%s/%s]",var.user_names, "dev")}"
#   appprod = "${formatlist("serviceAccount:${var.gcp_project}.svc.id.goog[%s/%s]",var.user_names, "prod")}"
# }