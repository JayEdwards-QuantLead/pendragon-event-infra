output "gcs_bucket_name" {
  description = "The name of the GCS bucket for the Kassandra project."
  value       = google_storage_bucket.data_lake.name
}

output "artifact_registry_repository" {
  description = "The full name of the Artifact Registry repository for the Kassandra engine."
  value       = google_artifact_registry_repository.docker_repo.name
}

output "cloud_run_service_url" {
  description = "The URL of the deployed Kassandra Cloud Run service."
  value       = google_cloud_run_v2_service.kassandra_engine_service.uri
}

output "service_account_email" {
  description = "The email of the dedicated service account for the Kassandra engine."
  value       = google_service_account.service_account.email
}