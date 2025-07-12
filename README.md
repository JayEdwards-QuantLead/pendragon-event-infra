Pendragon Event-Driven Infrastructure (pendragon-kassandra)
This repository contains the Terraform code to define and deploy the foundational cloud infrastructure for the Kassandra trading engine on Google Cloud Platform (GCP). This engine is specifically designed for trading on prediction markets like Kalshi and Polymarket.
Overview
This Terraform configuration automates the setup of a secure, scalable, and completely isolated environment for the Kassandra engine. It provisions the following core components within the pendragon-kassandra GCP project:
Google Cloud Storage (GCS): A central data lake bucket to store all trade logs, market data, and results related to prediction market strategies.
Google Artifact Registry: A private, secure repository to store the Docker container image for the Kassandra engine.
IAM Service Account: A dedicated, non-human identity for the Kassandra engine with the minimum necessary permissions to operate.
Google Cloud Run Service: A fully configured, "always-on" serverless service (min_instance_count = 1). This is critical for maintaining the persistent WebSocket connection required by the Kalshi API for real-time market data.
Prerequisites
A Google Cloud Platform account with an active billing account.
The gcloud command-line tool installed and authenticated.
Terraform (version 1.0.0 or higher) installed.
Setup and Deployment
Follow these steps to deploy the infrastructure. These commands should be run from your terminal within the root of this repository.
1. Create the terraform.tfvars File
This is the most important step. Create a file named terraform.tfvars in this directory. This file will tell Terraform which GCP project to deploy to.
File: terraform.tfvars
project_id = "pendragon-kassandra"


2. Authenticate with GCP
If you haven't already, authenticate your local machine with GCP. This command will open a browser window for you to log in.
gcloud auth application-default login


3. Initialize Terraform
This command downloads the necessary Google Cloud provider plugins for Terraform.
terraform init


4. Plan and Apply the Infrastructure
First, run plan to see a preview of the resources that will be created. This is a safe check and will not change anything.
terraform plan


After reviewing the plan, apply the configuration to create the resources in your GCP project. You will be prompted to confirm by typing yes.
terraform apply


Infrastructure Outputs
After a successful apply, Terraform will display several outputs. These are important values you will need for your CI/CD pipeline and application configuration.
gcs_bucket_name: The name of the GCS bucket for data storage.
artifact_registry_repository: The full path to your private Docker repository.
cloud_run_service_url: The public URL for the "always-on" Kassandra engine service.
service_account_email: The email of the dedicated service account created for the Kassandra engine.
