output "vpc_self_link" {
  description = "The URI of the VPC being created"
  value       = google_compute_network.vpc.self_link
}

output "vpc_name" {
  description = "The name of the VPC being created"
  value       = google_compute_network.vpc.name
}

output "subnet_self_link" {
  description = "The URI of the subnet being created"
  value       = google_compute_subnetwork.subnet.self_link
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_ip_cidr_range" {
  description = "The IP CIDR range of the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}
