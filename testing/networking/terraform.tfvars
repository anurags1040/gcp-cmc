region_id  = "us-central1"
zone_id    = "us-central1-a"
project_id = "secretlab-199414"

subnets = {
  "gke-production" = {
    cidr_block = "10.90.34.0/26"
    subnet_private_access = "true"
    region_id = "us-central1"
    secondary_ranges = {
      gke-svc-cidr = "10.90.32.0/23"
      gke-pod-cidr = "10.90.0.0/19"
    }
  }
  "prod-internal-lb-range" = {
    cidr_block = "10.90.35.0/24"
    subnet_private_access = "true"
    region_id = "us-central1"
    secondary_ranges = {}
  }
  "cad-gke" = {
    cidr_block = "10.90.226.0/26"
    subnet_private_access = "true"
    region_id = "northamerica-northeast1"
    secondary_ranges = {
      gke-svc-cidr = "10.90.224.0/23"
      gke-pod-cidr = "10.90.192.0/19"
    }
  }
  "cad-lb" = {
    cidr_block = "10.90.227.0/24"
    subnet_private_access = "true"
    region_id = "northamerica-northeast1"
    secondary_ranges = {}
  }
}