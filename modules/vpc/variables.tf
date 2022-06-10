/******************************************
	GCP environment variables
 *****************************************/

variable "project_id" {
}

variable "region_id" {
  default = "us-central1"
}

variable "zone_id" {
  default = "us-central1-a"
}

variable "environment" {
  type = string
  default = "dev"
}

/******************************************
  Router variables
 *****************************************/

variable "cloudnat_router_name_prefix" {
  default = "cca-cloudmc-production-cloudnat-"
}

/******************************************
  VPC variables
 *****************************************/

variable "network_name" {
  default = "cloudmc-saas-vpc-1"
}

variable "subnets" {
  description = "A map of subnets to be created"
  type = map(object({
    cidr_block = string
    subnet_private_access = string
    region_id = string
    secondary_ranges = map(any)
  }))
  default = {}
}


locals {
  subnet_regions = distinct([ for subnet_name, subnet_details in var.subnets : subnet_details.region_id ])
}