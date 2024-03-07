variable "auto_create_subnetworks" {
  description = "Whether to create subnetworks automatically"
  type        = bool
  default     = false
}

variable "project_id" {
  description = "The project ID to deploy the VPC"
  type        = string
}

variable "region" {
  description = "The region to deploy the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_ip_range" {
  description = "The IP range of the subnet"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "machine_type" {
  description = "The machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "Number of nodes for the GKE cluster"
  type        = number
  default     = 3
}

variable "gke_node_pool_version" {
  description = "The version of the GKE node pool"
  type        = string
  default     = "latest"
}

variable "gke_node_pool_node_count" {
  description = "The number of nodes in the GKE node pool"
  type        = number
  default     = 3
}

variable "service_account_id" {
  description = "The service account ID for the GKE cluster"
  type        = string
}

variable "repository_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
}

variable "repository_description" {
  description = "The description of the Artifact Registry repository"
  type        = string
}

variable "ir_image_tag" {
  type        = string
  description = "tag of the latest image for ip-reverser"
}
