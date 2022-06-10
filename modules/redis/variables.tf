variable "project_id" {
  type    = string
  default = "cloudmc-saas-dev"
}

variable "region_id" {
  type    = string
  default = "us-central1"
}

variable "network" {
  default = "https://www.googleapis.com/compute/v1/projects/cloudmc-saas-production/global/networks/cloudmc-saas-vpc-1"
}

variable "instance_name" {
  type    = string
  default = "cloudmc-dev-redis"
}

variable "tier" {
  description = "Service tier of instance"
  type        = string
  default     = "STANDARD_HA"
}

variable "memory_size" {
  description = "Memory size in gb"
  default     = 1
}

variable "transit_encryption_mode" {
  description = "TLS mode of Redis instance"
  default     = "SERVER_AUTHENTICATION"
}

variable "location_id" {
  description = "Zone where Instance will be deployed"
  default     = "us-central1-a"
}

variable "alternative_location_id" {
  description = "Protects instance against zone failure"
  default     = "us-central1-b"
}

variable "redis_version" {
  description = "Version of Redis software"
  default     = "REDIS_6_X"
}

variable "display_name" {
  description = "Arbitrary/user provided name for instance"
  default     = "cloudmc-dev-redis"
}

variable "labels" {
  description = "Labels of the instance"
  type        = string
  default     = "dev-instance"
}
