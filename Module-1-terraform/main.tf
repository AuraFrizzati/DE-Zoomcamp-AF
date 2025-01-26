terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region

}

resource "google_storage_bucket" "demo_bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = "example_dataset"
  location   = var.location

}


