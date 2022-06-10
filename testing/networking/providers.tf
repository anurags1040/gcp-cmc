terraform {
  required_version = "~> 0.13.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.48"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_id
  zone    = var.zone_id
}

provider "google-beta" {
  project = var.project_id
  region  = var.region_id
  zone    = var.zone_id
}