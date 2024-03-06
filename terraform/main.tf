module "vpc" {
  source = "./modules/gcp/vpc"

  project_id      = var.project_id
  region          = var.region
  vpc_name        = var.vpc_name
  subnet_name     = var.subnet_name
  subnet_ip_range = var.subnet_ip_range
}

module "gke" {
  source = "./modules/gcp/gke"

  project_id         = var.project_id
  region             = var.region
  cluster_name       = var.cluster_name
  machine_type       = var.machine_type
  node_count         = var.node_count
  vpc_name           = module.vpc.vpc_name
  subnet_name        = module.vpc.subnet_name
  service_account_id = var.service_account_id
}

resource "google_artifact_registry_repository" "image_repository" {
  location      = var.region
  repository_id = var.repository_name
  description   = var.repository_description

  format = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository" "helm_repository" {
  location      = var.region
  repository_id = "${var.repository_name}-helm-chart"
  description   = "${var.repository_description} Helm Chart Repository"

  format = "kfp"
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  depends_on = [module.gke]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}
provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"
  values           = [file("./argocd.yaml")]

  depends_on = [data.google_container_cluster.gke_cluster]
}

resource "helm_release" "ip_reverser" {
  name             = "prod-ip-reverser"
  repository       = "https://femi-lawal.github.io/source-ip-reverser"
  chart            = "ip-reverser"
  namespace        = "ip-reverser"
  create_namespace = true

  set {
    name  = "image.tag"
    value = var.ir_image_tag
  }
}
