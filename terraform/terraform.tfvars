#Subnetwork CIDR ranges
subnetwork_cidr = "10.128.0.0/20"
pod_cidr        = "10.116.0.0/14"
services_cidr   = "10.120.0.0/20"

# GCP Settings
gcp_project = "jvillarreal-sandbox-360616"
gcp_region  = "us-central1"

#Service Account
service_account = "idp-robot@jvillarreal-sandbox-360616.iam.gserviceaccount.com"

#GKE Settings
gke_username = "username"
gke_password = "password"

#Cluster 
cluster    = "jvillarreal-sandbox-360616-gke"
max_cpu    = 40
max_memory = 96

#Node
gke_num_nodes      = 1
autoscale_min_node = 0
autoscale_max_node = 3
machine_type       = "e2-standard-8"


#Bucket Settings
bucket-name   = "jvillarreal-sandbox-360616-tfstate"
storage-class = "REGIONAL"