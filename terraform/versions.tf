terraform {
  required_version = ">= 1.5.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.74.0"
    }
  }
  backend "gcs" {
    bucket = "terraform-state-647"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
