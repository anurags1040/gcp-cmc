/******************************************
	GCP environment variables
 *****************************************/

variable "project_id" {
}

variable "gcp_services" {
  type = list(string)
  description = "List of GCP services to enable on project"
  default = [
    "servicenetworking.googleapis.com",
  ]
}

variable "region_id" {
  default = "us-central1"
}

variable "zone_id" {
  default = "us-central1-a"
}

variable "application" {
  type    = string
  default = "cloudmc-saas"
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