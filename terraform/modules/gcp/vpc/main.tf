resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_range
  network       = google_compute_network.vpc.self_link
  region        = var.region
  project       = var.project_id
}

resource "google_compute_firewall" "allow_ingress_http_https" {
  name      = "allow-ingress-http-https"
  project   = var.project_id
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # The source ranges for the internet
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_egress_all" {
  name               = "allow-egress-all"
  project            = var.project_id
  network            = google_compute_network.vpc.name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
  # You can restrict egress by applying target tags or service accounts to match specific resources
}
