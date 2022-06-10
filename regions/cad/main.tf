locals {
  environment = "cad"
  name_prefix = "${var.application}-${local.environment}"
}

data "google_client_config" "current" {
}

data "google_project" "project" {
  project_id = var.project_id
}

module "gcp-gke" {
  source = "../../modules/gcp-gke"

  project_id        = data.google_client_config.current.project
  region_id         = data.google_client_config.current.region
  vpc_network       = var.vpc_network
  vpc_subnetwork    = var.vpc_subnetwork
  mastercidrblock   = var.mastercidrblock
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  cluster_name        = var.cluster_name
  cluster_location    = var.cluster_location
  node_locations      = var.node_locations
  cluster_description = var.cluster_description
  node_pool_name      = var.node_pool_name
  node_tags           = var.node_tags

  cloudmc-ingress-ip           = var.cloudmc-ingress-ip
  cloudmc-ssl-policy           = var.cloudmc-ssl-policy
  cloudmc_security_policy_name = var.cloudmc_security_policy_name
}

module "database" {
  source = "../../modules/CloudSQL"

  project_id = data.google_client_config.current.project
  region_id  = data.google_client_config.current.region
  zone_id    = "${data.google_client_config.current.region}-a"

  instance_id = "cloudmc-mysql-cad"

  vpc_network = var.vpc_network

  environment = local.environment
}

module "redis" {
  source = "../../modules/redis"

  project_id              = data.google_client_config.current.project
  region_id               = data.google_client_config.current.region
  location_id             = "${data.google_client_config.current.region}-a"
  alternative_location_id = "${data.google_client_config.current.region}-b"

  network       = "https://www.googleapis.com/compute/v1/projects/${data.google_client_config.current.project}/global/networks/${var.vpc_network}"
  instance_name = var.redis_instance_name
  display_name  = var.redis_instance_name
  labels        = "${local.environment}-instance"
}