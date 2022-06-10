# Needed for Config Connector and Shared VPC

provider "google" {
  version = "3.53"
  credentials = file("/tmp/application_default_credentials.json")
  project = var.project_id
  region  = var.region_id
}

resource "google_service_account" "config_connector" {
  account_id   = "configconnector"
  display_name = "Config Connector Service Account"
}

resource "google_service_account" "ci-cd-pipeline" {
  account_id   = "ci-cd-pipeline"
  display_name = "Jenkins Service Account"
}

resource "google_service_account" "cloudsqlbackups" {
  account_id   = "cloudsqlbackups"
  display_name = "Cloudsqlbackups Service Account"
}

resource "google_service_account" "tf" {
  account_id   = "terraform"
  display_name = "Ops Terraform Service Account"
}

# Binding done to KMS in GKE main.tf
resource "google_service_account" "vault-unsealer" {
  account_id   = "gke-vault-unsealer"
  display_name = "Vault Unsealer Service Account"
}


module "project-iam-bindings" {
  source     = "terraform-google-modules/iam/google//modules/projects_iam"
  version    = "6.4.0"
  projects   = [var.project_id]
  mode       = "additive"
  depends_on = [google_service_account.config_connector, google_service_account.ci-cd-pipeline, google_service_account.cloudsqlbackups, google_service_account.tf]

  bindings = {
    "roles/container.admin" = [
      "serviceAccount:ci-cd-pipeline@${var.project_id}.iam.gserviceaccount.com",
      "group:operations_gcp@cloudops.com",
      "group:cloudmc@cloudops.com",
    ]
     "roles/owner" = [
      "serviceAccount:configconnector@${var.project_id}.iam.gserviceaccount.com",
      "serviceAccount:terraform@${var.project_id}.iam.gserviceaccount.com",
    ]
    "roles/cloudsql.admin" = [
      "serviceAccount:cloudsqlbackups@${var.project_id}.iam.gserviceaccount.com",
      "group:operations_gcp@cloudops.com",
      "group:cloudmc@cloudops.com",
    ]
  }
}

module "service_account-iam-bindings" {
  source     = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  depends_on = [google_service_account.config_connector]

  service_accounts = ["configconnector@${var.project_id}.iam.gserviceaccount.com"]
  project          = var.project_id
  mode             = "additive"

  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    ]
  }
}
