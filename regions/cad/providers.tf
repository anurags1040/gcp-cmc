terraform {
  # backend "gcs" {
  #   bucket = var.bucket_name
  #   prefix = var.prefix
  # }

  required_version = "~> 1.2.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.10.0"
    }
  }
}

provider "google" {
  # credentials = var.gcp_credentials
  project = var.project_id
  region  = var.region_id
}

# Needed for Config Connector
provider "google-beta" {
  # credentials = var.gcp_credentials
  project = var.project_id
  region  = var.region_id
}
