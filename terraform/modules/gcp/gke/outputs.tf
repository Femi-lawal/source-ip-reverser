output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke_cluster.name
}

output "gke_cluster_location" {
  description = "The location of the GKE cluster"
  value       = google_container_cluster.gke_cluster.location
}

output "gke_cluster_project" {
  description = "The project ID associated with the GKE cluster"
  value       = google_container_cluster.gke_cluster.project
}

output "gke_cluster_network" {
  description = "The network the GKE cluster is associated with"
  value       = google_container_cluster.gke_cluster.network
}

output "gke_cluster_subnetwork" {
  description = "The subnetwork the GKE cluster is associated with"
  value       = google_container_cluster.gke_cluster.subnetwork
}

output "gke_cluster_autopilot" {
  description = "Whether Autopilot mode is enabled for the GKE cluster"
  value       = google_container_cluster.gke_cluster.enable_autopilot
}
