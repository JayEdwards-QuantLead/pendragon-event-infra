provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "gcp_apis" {
  project              = var.project_id
  for_each             = toset(var.gcp_service_list)
  service              = each.key
  disable_on_destroy   = false
}

resource "google_storage_bucket" "data_lake" {
  project      = var.project_id
  name         = "${var.project_id}-kassandra-data"
  location     = var.region
  force_destroy = true
  uniform_bucket_level_access = true
  depends_on = [google_project_service.gcp_apis]
}

resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = "kassandra-engine-repo"
  description   = "Docker repository for the Kassandra (Kalshi) engine"
  format        = "DOCKER"
  depends_on    = [google_project_service.gcp_apis]
}

resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "kassandra-engine-sa"
  display_name = "Service Account for Kassandra Engine"
  depends_on   = [google_project_service.gcp_apis]
}

resource "google_storage_bucket_iam_member" "gcs_writer" {
  bucket = google_storage_bucket.data_lake.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_artifact_registry_repository_iam_member" "artifact_reader" {
  project    = google_artifact_registry_repository.docker_repo.project
  location   = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_cloud_run_v2_service" "kassandra_engine_service" {
  project  = var.project_id
  name     = "kassandra-engine"
  location = var.region

  template {
    service_account = google_service_account.service_account.email
    scaling {
      min_instance_count = 1
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      ports { container_port = 8080 }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
  depends_on = [google_project_service.gcp_apis]
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  project  = google_cloud_run_v2_service.kassandra_engine_service.project
  location = google_cloud_run_v2_service.kassandra_engine_service.location
  name     = google_cloud_run_v2_service.kassandra_engine_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}