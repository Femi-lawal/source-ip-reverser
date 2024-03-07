# IP Reverser Project Overview

The IP Reverser Project is a comprehensive solution designed to deploy an IP address reverser application on Google Cloud Platform (GCP). This project leverages Terraform to create and manage infrastructure, GitHub Actions for CI/CD pipelines, and Helm for application deployment on a Kubernetes Engine cluster.

## Infrastructure

The project uses Terraform to provision the underlying infrastructure on GCP. The Terraform modules are responsible for setting up the following resources:

- **VPC (Virtual Private Cloud):** A custom VPC is created to provide a logically isolated section of the GCP where the resources run.

- **Subnet:** Within the VPC, a subnet is provisioned to allocate a portion of the VPC's IP address range where the resources are placed.

- **GKE (Google Kubernetes Engine) Cluster:** A managed Kubernetes cluster is created within the specified VPC and subnet. This cluster hosts the IP Reverser application.

## IP Reverser Application

The IP Reverser is a web application that captures the originating public IP address of any incoming request and returns the IP address in a reversed format. For example, if the incoming IP address is "1.2.3.4", the application will return "4.3.2.1".

### Docker Image

The application is containerized using Docker, allowing it to be deployed consistently across any environment. The Docker image is built and pushed to GCP's Artifact Registry as part of the CI/CD pipeline, facilitated by GitHub Actions.

## CI/CD Pipeline

GitHub Actions are used to automate the build and deployment process. The pipeline performs the following actions:

1. **Build Docker Image:** On every push to the repository, the Docker image for the IP Reverser application is built.

2. **Push Docker Image:** The built image is pushed to GCP's Artifact Registry.

3. **Deploy Helm Chart:** The IP Reverser Helm chart, which defines the deployment of the application to the GKE cluster, is updated with the new image tag and deployed.

## Helm Chart

The Helm chart for the IP Reverser application outlines the deployment specifications, including the Docker image to use, desired replica count, and any required environment variables. It also includes a PostgreSQL database deployment, providing the necessary backend storage for the application.

The Helm chart ensures that the application is exposed to the internet through a LoadBalancer service, allowing public access to the IP Reverser web interface.

## Getting Started

To deploy the IP Reverser project, you will need:

- A GCP account with the necessary permissions to create the resources.
- Terraform installed on your local machine or CI/CD environment.
- Helm installed for deploying the application chart.
- Access to GitHub for managing the repository and actions.

## Usage

1. **Infrastructure Setup:** Navigate to the Terraform configuration directory and run `terraform init` followed by `terraform apply` to provision the infrastructure.

2. **Application Deployment:** Once the infrastructure is provisioned, merge your application changes to trigger the GitHub Actions pipeline, which builds the Docker image and deploys the application via Helm.

3. **Access Application:** After deployment, the IP Reverser application can be accessed through the LoadBalancer's public IP address provided by GKE.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
