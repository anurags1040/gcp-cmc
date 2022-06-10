# Enable API
resource "google_project_service" "api" {
  project = var.project_id
  service = "redis.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_redis_instance" "cache" {
  name                    = var.instance_name
  tier                    = var.tier
  memory_size_gb          = var.memory_size
  transit_encryption_mode = var.transit_encryption_mode
  project                 = var.project_id

  location_id             = var.location_id
  alternative_location_id = var.alternative_location_id

  authorized_network = var.network

  connect_mode  = "PRIVATE_SERVICE_ACCESS"
  redis_version = var.redis_version
  display_name  = var.display_name


  labels = {
    name = var.labels
  }

  maintenance_policy {
    weekly_maintenance_window {
      day = "SATURDAY"
      start_time {
        hours   = 09
        minutes = 30
        seconds = 0
        nanos   = 0
      }
    }
  }

  depends_on = [
    google_project_service.api
  ]
}
