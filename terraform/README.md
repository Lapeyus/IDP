## ArgoCD Platform Rollout for Crisp
This document describes the Terraform requirements/updates that will be needed to implement the ArgoCD plaform into a GKE cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.52.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/compute_network) | resource |
| [google_compute_network.vpc2](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.client-vpc](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.client-vpc2](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/container_cluster) | resource |
| [google_container_cluster.secondarycluster](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/container_cluster) | resource |
| [google_container_node_pool.primary_node](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.secondary_node](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/container_node_pool) | resource |
| [google_container_registry.registry1](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/container_registry) | resource |
| [google_project_service.gcp_resource_manager_api](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/project_service) | resource |
| [google_storage_bucket.tf-bucket](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/resources/storage_bucket) | resource |
| [time_sleep.gcp_wait_crm_api_enabling](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_client_config.client](https://registry.terraform.io/providers/hashicorp/google/3.52.0/docs/data-sources/client_config) | data source |
| [template_file.access_token](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_max_node"></a> [autoscale\_max\_node](#input\_autoscale\_max\_node) | The maximum number of worker nodes available per zone. | `number` | `5` | no |
| <a name="input_autoscale_min_node"></a> [autoscale\_min\_node](#input\_autoscale\_min\_node) | The minimum number of worker nodes available per zone. | `number` | `1` | no |
| <a name="input_bucket-name"></a> [bucket-name](#input\_bucket-name) | The name of the Google Storage Bucket to create to hold TF state. | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The name of the cluster where ArgoCD will reside. | `string` | n/a | yes |
| <a name="input_gcp_project"></a> [gcp\_project](#input\_gcp\_project) | GCP project name | `string` | `"crisp-build"` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region | `string` | `"us-central1"` | no |
| <a name="input_gke_num_nodes"></a> [gke\_num\_nodes](#input\_gke\_num\_nodes) | number of gke nodes | `number` | `1` | no |
| <a name="input_gke_password"></a> [gke\_password](#input\_gke\_password) | GKE password | `string` | `""` | no |
| <a name="input_gke_username"></a> [gke\_username](#input\_gke\_username) | GKE username | `string` | `""` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The type of machine to run the node. | `string` | `"e2-standard-8"` | no |
| <a name="input_max_cpu"></a> [max\_cpu](#input\_max\_cpu) | The maximum CPU in Gbs for the cluster | `number` | `40` | no |
| <a name="input_max_memory"></a> [max\_memory](#input\_max\_memory) | The maximum memory for the cluster | `number` | `96` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | n/a | `string` | n/a | yes |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_storage-class"></a> [storage-class](#input\_storage-class) | The storage class of the Storage Bucket to create | `string` | `"REGIONAL"` | no |
| <a name="input_subnetwork_cidr"></a> [subnetwork\_cidr](#input\_subnetwork\_cidr) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
