provider "google" {
  version     = "3.53"
  credentials = file("/var/jenkins_home/gcp/cloudops_sa_ops_dev")
  project = var.project_id
  region  = var.region_id
}

# Needed for Config Connector
provider "google-beta" {
  credentials = file("/var/jenkins_home/gcp/cloudops_sa_ops_dev")
  project     = var.project_id
  region      = var.region_id
}
