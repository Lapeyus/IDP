# configsync and config connector on GKE

This repository contains the necessary resources to set up a Kubernetes cluster on Google Cloud Platform (GCP) using Google Kubernetes Engine (GKE). The following resources are included:

## google_client_config.clientdata.template_file.access_token

This resource is used to authenticate with GCP APIs. It provides an access token that can be used in subsequent API requests.

## google_compute_network.vpc

This resource creates a Virtual Private Cloud (VPC) network on GCP. This VPC will be used to host the Kubernetes cluster.

## google_compute_subnetwork.gke

This resource creates a subnetwork within the VPC network. This subnetwork will be used to host the GKE nodes.

## google_container_cluster.primary

This resource creates the GKE cluster itself. It specifies the number of nodes, node type, and other relevant configuration options.

## google_container_node_pool.primary_node_pool

This resource creates a pool of nodes within the GKE cluster. These nodes will be used to run Kubernetes workloads.

## google_gke_hub_feature.feature

This resource enables the GKE Hub feature on the GKE cluster. GKE Hub allows for centralized management of multiple Kubernetes clusters.

## google_gke_hub_feature_membership.feature_member

This resource adds the GKE cluster to the GKE Hub.

## google_gke_hub_membership.membership

This resource creates a membership resource in the GKE Hub. This membership resource represents the GKE cluster.

## google_project_iam_binding.idp-robot

This resource grants the necessary IAM roles to the service account used by the GKE cluster.

## google_project_service.gcp_services[0], google_project_service.gcp_services[1], google_project_service.gcp_services[2]

These resources enable the necessary GCP services for the GKE cluster.

## google_service_account.idp-robot

This resource creates a service account that will be used by the GKE cluster.

## google_service_account_iam_binding.workload_identity_user

This resource grants the workload identity user role to the service account created earlier. This role allows the GKE cluster to authenticate with other GCP services.

## helm_release.argo

This resource installs Argo onto the GKE cluster. Argo is a Kubernetes-native workflow engine.

## kubernetes_manifest.connector_config

This resource creates a Kubernetes ConfigMap that holds configuration information for the connector used by Argo.

## kubernetes_secret.git-creds["default"]

This resource creates a Kubernetes secret that holds Git credentials. These credentials are used by Argo when interacting with Git repositories.

## Installation Steps

Before installing these resources, ensure that you have the following prerequisites:

- A GCP project
- Access to the GCP APIs
- The gcloud CLI tool installed
- Terraform installed

To install these resources, follow these steps:

1. Clone this repository.
2. Navigate to the cloned repository directory.
3. Run `terraform init` to initialize the Terraform modules.
4. Run `terraform plan` to preview the changes that will be made.
5. If the plan looks correct, run `terraform apply` to create the resources.

Once the resources have been created, you can use Argo to run workflows on the GKE cluster. The Kubernetes resources created by this Terraform code provide the foundation for running these workflows.

 

Here's a brief explanation of each variable:

- `gcp_region`: specifies the Google Cloud Platform region.
- `gcp_project`: specifies the name of the GCP project.
- `enabled_services`: specifies a list of enabled GCP services.
- `config_management`: specifies the configuration for Anthos Config Management.
- `aggregation_interval`: specifies the interval at which logs are aggregated.
- `flow_sampling`: specifies the percentage of flows to sample.
- `metadata`: specifies the metadata to include in logs.
- `subnetwork_cidr`: specifies the CIDR block for the subnetwork.
- `pod_cidr`: specifies the CIDR block for pods.
- `services_cidr`: specifies the CIDR block for services.
- `cluster_name`: specifies the name of the Kubernetes cluster.
- `max_cpu`: specifies the maximum CPU usage for the cluster.
- `max_memory`: specifies the maximum memory usage for the cluster.
- `autoscale_min_node`: specifies the minimum number of worker nodes available per zone.
- `autoscale_max_node`: specifies the maximum number of worker nodes available per zone.
- `machine_type`: specifies the type of machine to run the node.
- `bucket-name`: specifies the name of the Google Storage Bucket to create to hold TF state.
- `storage-class`: specifies the storage class of the Storage Bucket to create.

To use these variables, you'll need to define their values either by passing them as command line arguments or by using a `.tfvars` file. 

Before running the Terraform configuration, you'll also need to install Terraform on your system. Here are the steps to do so:

1. Download the appropriate version of Terraform for your operating system from the official website: https://www.terraform.io/downloads.html
2. Extract the downloaded archive to a directory on your system.
3. Add the directory to your system's PATH environment variable.

Once you've installed Terraform, you can run the configuration by navigating to the directory containing the configuration files and running the following commands:

1. `terraform init` - This command initializes the Terraform working directory and downloads any necessary plugins.
2. `terraform plan` - This command creates an execution plan showing what actions Terraform will take when you apply the configuration.
3. `terraform apply` - This command applies the changes specified in the configuration.

 