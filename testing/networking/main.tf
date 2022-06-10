locals {
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace
  name_prefix = "${var.application}-${local.environment}"
}

# Enable APIs
resource "google_project_service" "project" {
  for_each = toset(var.gcp_services)

  project = var.project_id
  service = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "vpc" {
  source = "../../modules/vpc"

  project_id           = var.project_id
  environment          = local.environment
  # cloudnat_router_name_prefix = "${local.name_prefix}-cloudnat-${var.region_id}"
  network_name         = "${local.name_prefix}-vpc"
  subnets              = var.subnets
}
