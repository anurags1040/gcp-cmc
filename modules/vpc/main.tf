/******************************************
	VPC configuration
 *****************************************/

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0.0"

  project_id      = var.project_id
  network_name    = var.network_name
  routing_mode    = "GLOBAL"
  shared_vpc_host = false

  subnets = [ for sname, sdetails in var.subnets : {
    "subnet_name" = "${var.network_name}-${sname}"
    "subnet_ip" = sdetails.cidr_block
    "subnet_region" = sdetails.region_id
    "subnet_private_access" = sdetails.subnet_private_access
  }]

  # Has to be defined for Staging and dev directly in the VPC due to Shared VPC setup
  secondary_ranges = { for sname, sdetails in var.subnets :
    "${var.network_name}-${sname}" => [ for secondary_range_name, secondary_range_cidr in sdetails.secondary_ranges : {
      "range_name" = secondary_range_name
      "ip_cidr_range" = secondary_range_cidr
    }]
  }
}

/******************************************
	Private service access for CloudSQL
 *****************************************/

module "sql-db_private_service_access" {
  source        = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version       = "4.3.0"

  project_id    = var.project_id
  vpc_network   = module.vpc.network_name
  address       = "10.90.99.0"
  prefix_length = 24

  depends_on = [
    module.vpc,
  ]
}

/******************************************
	Cloud NAT configuration
 *****************************************/

module "cloud_router" {
  for_each = toset(local.subnet_regions)

  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.3"

  name    = "${var.cloudnat_router_name_prefix}-${each.key}"
  project = var.project_id
  region  = each.key
  network = module.vpc.network_name
  nats = [{
    name = "cloudmc-saas-nat-${var.environment}-${each.key}"
  }]
}
