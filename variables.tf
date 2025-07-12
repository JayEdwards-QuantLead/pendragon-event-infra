variable "project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
  default     = "pendragon-kassandra"
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "us-central1"
}

variable "gcp_service_list" {
  description = "The list of GCP APIs that are required for the project."
  type        = list(string)
  default     = ["iam.googleapis.com", "run.googleapis.com", "storage.googleapis.com", "artifactregistry.googleapis.com", "cloudbuild.googleapis.com"]
}