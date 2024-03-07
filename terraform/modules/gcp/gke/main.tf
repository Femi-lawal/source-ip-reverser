resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "GKE Service Account"
}

# Artifact Registry Reader role
resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Storage Object Viewer role (for accessing objects in Google Cloud Storage)
resource "google_project_iam_member" "storage_object_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Logging Log Writer role (for writing logs to Cloud Logging)
resource "google_project_iam_member" "logging_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Monitoring Metric Writer role (for writing metrics to Cloud Monitoring)
resource "google_project_iam_member" "monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Pub/Sub Publisher role (optional, if your application needs to publish messages to Pub/Sub)
resource "google_project_iam_member" "pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.vpc_name
  subnetwork = var.subnet_name

  deletion_protection = false

  # Enable Autopilot mode
  enable_autopilot = true

  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  # Assigning the created service account to the cluster
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.default.email
    }
  }
}

resource "google_project_service" "gke" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_dependent_services = false
}
