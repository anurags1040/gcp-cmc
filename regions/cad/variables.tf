variable "environment" {
  type        = string
  description = "Name of environment"
}

variable "gcp_credentials" {
  description = "Service Account key"
  type        = string
}
variable "project_id" {
  description = "Project ID" #host_project for Shared VPC
  type        = string

}

variable "application" {
  type    = string
  default = "cloudmc-saas"
}


variable "region_id" {
  description = "Region Id"
  type        = string
}

# variable "bucket_name" {
#   description = "Backend bucket name"
#   type        = string
# }
# variable "prefix" {
#   description = "Prefix"
#   type        = string
# }

# variable "staging_service_project_number" { # Service project for Shared VPC
#   description = "Service Project Number for Shared VPC"
#   type        = string
# }

# variable "dev_service_project_number" { # Service project for Shared VPC
#   description = "Service Project 2 Number for Shared VPC"
#   type        = string
# }

# variable "shared_vpc_subnets" {
#   description = "Subnets for Shared VPC"
#   type        = list(any)
#   # default = ["cloudmc-saas-vpc-1-gke-staging", "cloudmc-saas-vpc-1-gke-dev"]
# }

# variable "shared_vpc_subnets_region" {
#   description = "Shared VPC subnets region"
#   type        = string
# }



/******************************************
	GCP environment variables
 *****************************************/
variable "vpc_network" {
  description = "Network of the cluster"
  type        = string
  # VPC where GKE will be deployed
}

variable "vpc_subnetwork" {
  description = "Subnetwork of the cluster"
  type        = string
  # Subnet where GKE will be deployed
}

/******************************************
	GKE Cluster variables
 *****************************************/
variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_location" {
  description = "Location of the cluster"
  type        = string

}

variable "node_locations" {
  description = "Location of the NodePool"
  type        = list(string)

}

variable "cluster_description" {
  type = string

}

# variable "node_version" {
#   description = "Version of the node"
#   type        = string
#
# }

variable "min_master_version" {
  description = "minimum version that the cluster master can have"
  type        = string
  default     = "latest"
}

variable "mastercidrblock" {
  description = "master CIDR attached to the Cluster"
  type        = string

}

variable "ip_range_pods" {
  description = "IP range of Pods"
  type        = string

}

variable "ip_range_services" {
  description = "IP range of services"
  type        = string

}

variable "master_authorized_cidr_1" {
  description = "Authorized range 1"
  type        = string
  default     = "172.26.60.5/32" # tools.svc.cloudops.net
}

variable "master_authorized_cidr_2" {
  description = "Authorized range 2"
  type        = string
  default     = "172.26.10.140/32" # jenkins.ops.svc.cloudops.net
}

variable "master_authorized_cidr_3" {
  description = "Authorized range 3"
  type        = string
  default     = "172.26.60.158/32" # coo-r1-cloudmcaas-devteam-svc-cloudops.net
}
variable "master_authorized_cidr_4" {
  description = "Authorized range 4"
  type        = string
  default     = "172.16.0.0/19" # Jenkins Pod addr range
}
variable "master_authorized_cidr_1_name" {
  description = "Authorized range 1 name"
  type        = string
  default     = "CCA tools.svc.cloudops.net"
}

variable "master_authorized_cidr_2_name" {
  description = "Authorized range 2 name"
  type        = string
  default     = "CCA jenkins.ops.svc.cloudops.net"
}

variable "master_authorized_cidr_3_name" {
  description = "Authorized range 3 name"
  type        = string
  default     = "CCA coo-r1-cloudmcaas-devteam-svc-cloudops.net"
}

variable "master_authorized_cidr_4_name" {
  description = "Authorized range 4 name"
  type        = string
  default     = "Jenkins Pod addr range"
}


/******************************************
	GKE Cluster Node Pool variables
 *****************************************/

variable "node_pool_name" {
  description = "Node Pool Name"
  type        = string
  # default = "cloudmc-pool-1"
}

variable "pool_node_count" {
  description = "Node Pool count"
  default     = 2 # In regional or multi-zonal clusters, this is the number of nodes per zone.
}

variable "min_node_count_per_zone" {
  description = "Minimum Node Pool Count per zone"
  default     = 1
}

variable "max_node_count_per_zone" {
  description = "Max Node Pool count per zone"
  default     = 2
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "node_disk_size" {
  description = "Node disk size"
  default     = 20
}

variable "node_tags" {
  description = "Node Tags"
  type        = list(string)

}

variable "nodes_auto_upgrade" {
  description = "Node Upgrade Auto"
  default     = true
}

variable "nodes_auto_repair" {
  description = "Node Auto Repair"
  default     = true
}

variable "cloudmc-ingress-ip" {
  description = "Ingress IP value"
  type        = string
}

variable "cloudmc-ssl-policy" {
  description = "SSL policy"
  type        = string
}

variable "cloudmc_security_policy_name" {
  description = "Security policy name"
  type        = string
}

### REDIS

variable "redis_instance_name" {
  description = "Redis instance name"
  type        = string
}