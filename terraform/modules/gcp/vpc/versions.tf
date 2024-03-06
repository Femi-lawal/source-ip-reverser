terraform {
  required_version = ">= 1.5.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.74.0"
    }
  }
}
