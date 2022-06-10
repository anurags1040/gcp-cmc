/******************************************
	GCP environment variables
 *****************************************/

variable "project_id" {
  default = "cloudmc-saas-dev"
}

variable "region_id" {
  default = "us-central1"
}

variable "zone_id" {
  default = "us-central1-a"
}


/******************************************
	CloudSQL variables
 *****************************************/

variable "instance_id" {
  default = "cloudmc-mysql-dev"
}

variable "instance_tier" {
  default = "db-n1-standard-2"
}

variable "authorized_networks" {
  type = list(any)
  default = [
    {
      value = "0.0.0.0/0" # Cannot authorize specific ranges when using private IP only (https://cloud.google.com/sql/docs/mysql/authorize-networks#limitations)
      name  = "GKE subnet"
    }
  ]
}

variable "vpc_network" {
  default = "cloudmc-saas-vpc-1"
}

variable "instance_disk_size" {
  default = 30
}

variable "maintenance_day" {
  default = 7 # Sunday
}

variable "maintenance_hour" {
  default = 8 # in UTC, 3 - 4 AM EDT
}

variable "database_flags" {
  type = list(any)
  default = [
    {
      name  = "default_time_zone"
      value = "+00:00"
    },
    {
      name  = "sql_mode"
      value = "NO_ENGINE_SUBSTITUTION"
    },
    {
      name  = "explicit_defaults_for_timestamp"
      value = "off"
    },
  ]
}


variable "databases" {
  type = list(any)
  default = [
    {
      name      = "cloudmc"
      charset   = "utf8"
      collation = "utf8_general_ci"
    },
    {
      name      = "cloudmc_audit"
      charset   = "utf8"
      collation = "utf8_general_ci"
    },
    {
      name      = "cloudmc_content"
      charset   = "utf8"
      collation = "utf8_general_ci"
    },
  ]
}

variable "db_user" {
  default = "cloudmc"
}

variable "user_host_cidr" {
  default = "cloudsqlproxy~10.90.%.%"
}

variable "additional_users" {
  type        = list(any)
  description = "List of additional users to grant access to"
  default     = []
}

variable "mysql_version" {
  type        = string
  description = "MySQL version to deploy"
  default     = "MYSQL_8_0"
}

variable "environment" {
  type        = string
  description = "Environment deploying to e.g. dev|staging|production"
  default     = "dev"
}

variable "bucket_storage_class" {
  type        = string
  description = "GCS bucket storage class to use"
  default     = "STANDARD"
}

locals {
  scheduled_functions = {
    hourly = {
      job_type     = "backup"
      job_schedule = "0 */1 * * *"
    },
    weekly = {
      job_type     = "export"
      job_schedule = "5 0 * * SUN"
    }
  }
}