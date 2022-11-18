# GCP Settings
gcp_project = "config-conector-sample"
gcp_region  = "us-central1"

#Subnetwork CIDR ranges
subnetwork_cidr = "10.10.0.0/24"   #256
services_cidr   = "192.168.1.0/24" #256
pod_cidr        = "172.16.0.0/20"  #4,096

#Service Account
service_account = "idp-robot@config-conector-sample.iam.gserviceaccount.com"

#GKE Settings
gke_username = "username"
gke_password = "password"

#Cluster 
cluster_name = "sauron"
max_cpu      = 40
max_memory   = 96

#Node
gke_num_nodes      = 1
autoscale_min_node = 0
autoscale_max_node = 10
machine_type       = "e2-standard-8"


#Bucket Settings
bucket-name   = "config-conector-sample-tfstate"
storage-class = "REGIONAL"