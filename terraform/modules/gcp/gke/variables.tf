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
  description = "Initial number of nodes for the GKE cluster"
  type        = number
  default     = 3
}

variable "project_id" {
  description = "The project ID to deploy the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region to deploy the GKE cluster"
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

variable "service_account_id" {
  description = "The service account ID for the GKE cluster"
  type        = string
}
