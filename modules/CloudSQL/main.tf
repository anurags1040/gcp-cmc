/**
 * # CloudSQL module for CloudMC
 *
 * This module is used to deploy a CloudSQL instance, bucket for backups and scheduled
 * functions for automated backup jobs (hourly and weekly) for CloudMC.
 *
 * ## Generating docs
 *
 * You can generate docs using `terraform-docs.io`. To update the README.md, you can run the following command:
 *
 * ```
 * terraform-docs markdown table . > README.md
 * ```
 *
 */

locals {
  apis = [
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "sql-component.googleapis.com",
  ]
}

# Enable API
resource "google_project_service" "api" {
  for_each = toset(local.apis)

  project = var.project_id
  service = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "sql-db_mysql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "~> 10.1.0"

  database_version            = var.mysql_version
  name                        = var.instance_id
  project_id                  = var.project_id
  region                      = var.region_id
  zone                        = var.zone_id
  tier                        = var.instance_tier
  disk_size                   = var.instance_disk_size
  maintenance_window_day      = var.maintenance_day
  maintenance_window_hour     = var.maintenance_hour
  user_name                   = var.db_user
  user_host                   = var.user_host_cidr # cidr authorized for the user
  additional_users            = var.additional_users
  additional_databases        = var.databases
  database_flags              = var.database_flags

  # This block makes CloudSQL private
  ip_configuration = {
    authorized_networks = var.authorized_networks
    ipv4_enabled        = false
    private_network     = "projects/${var.project_id}/global/networks/${var.vpc_network}"
    require_ssl         = false
    allocated_ip_range  = null
  }

  backup_configuration = {
    binary_log_enabled = true
    enabled            = true
    location           = var.region_id
    start_time         = "00:00"
    retained_backups   = 7
    retention_unit     = "COUNT"
    transaction_log_retention_days = 7
  }

  depends_on = [
    google_project_service.api["sql-component.googleapis.com"]
  ]
}


# # Route export/import for interconnect
# resource "google_compute_network_peering_routes_config" "peering_cloudsql_routes1" {
#   peering    = "cloudsql-mysql-googleapis-com"
#   network    = var.vpc_network
#   depends_on = [module.sql-db_mysql]
#   project    = var.project_id

#   import_custom_routes = true
#   export_custom_routes = true
# }

resource "google_compute_network_peering_routes_config" "peering_cloudsql_routes2" {
  peering    = "servicenetworking-googleapis-com"
  network    = var.vpc_network
  depends_on = [module.sql-db_mysql]
  project    = var.project_id

  import_custom_routes = true
  export_custom_routes = true
}

resource "random_id" "bucket" {
  prefix      = "cmc-sql-export-${var.environment}-${var.region_id}-"
  byte_length = 2
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name          = random_id.bucket.dec
  project_id    = var.project_id
  location      = var.region_id
  storage_class = var.bucket_storage_class

  lifecycle_rules = [{
    condition = {
      age = 30
    },
    action = {
      type = "Delete"
    },
  }]

  depends_on = [module.sql-db_mysql]
}

# This has to be done outside of bucket module due to the module's dependency on for_each
resource "google_storage_bucket_iam_member" "sql_db_mysql" {
  bucket = module.bucket.bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.sql-db_mysql.instance_service_account_email_address}"
}