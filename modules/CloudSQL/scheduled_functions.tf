# Needed for Backup automation
resource "google_app_engine_application" "app" {
  depends_on  = [module.sql-db_mysql]
  project     = var.project_id
  location_id = "us-central"
}

resource "local_file" "hourly_main" {
  content = templatefile("${path.module}/backups/scripts/hourly/main.py", {
    database_name  = var.instance_id
    gcp_project_id = var.project_id
  })
  filename = "${path.root}/backups/scripts/generated_hourly/main.py"
}

resource "local_file" "hourly_requirements" {
  source   = "${path.module}/backups/scripts/hourly/requirements.txt"
  filename = "${path.root}/backups/scripts/generated_hourly/requirements.txt"
}

resource "local_file" "weekly_main" {
  content = templatefile("${path.module}/backups/scripts/weekly/main.py", {
    database_name  = var.instance_id
    gcp_project_id = var.project_id
  })
  filename = "${path.root}/backups/scripts/generated_weekly/main.py"
}

resource "local_file" "weekly_requirements" {
  source   = "${path.module}/backups/scripts/weekly/requirements.txt"
  filename = "${path.root}/backups/scripts/generated_weekly/requirements.txt"
}

# Backup automation
module "scheduled-function" {
  for_each   = local.scheduled_functions

  source  = "terraform-google-modules/scheduled-function/google"
  version = "2.3.0"

  project_id                     = var.project_id
  job_name                       = "${each.key}-cloudsql-${each.value.job_type}-cloudmc-saas-${var.environment}"
  job_schedule                   = each.value.job_schedule
  time_zone                      = "America/New_York"
  function_entry_point           = "${each.value.job_type}_job"
  function_service_account_email = "cloudsqlbackups@${var.project_id}.iam.gserviceaccount.com"
  function_source_directory      = "${path.root}/backups/scripts/generated_${each.key}"
  function_name                  = "${each.key}-cloudsql-${each.value.job_type}-cloudmc-saas-${var.environment}"
  function_runtime               = "python38"
  function_environment_variables = {
    "BUCKET" = random_id.bucket.dec
  }
  topic_name = "${each.key}-cloudsql-${each.value.job_type}"
  region     = var.region_id

  depends_on = [
    google_project_service.api["cloudfunctions.googleapis.com"],
    google_project_service.api["cloudscheduler.googleapis.com"],
    google_project_service.api["cloudbuild.googleapis.com"],
    module.sql-db_mysql,
    google_app_engine_application.app,
    local_file.hourly_main,
    local_file.hourly_requirements,
    local_file.weekly_main,
    local_file.weekly_requirements,
  ]
}