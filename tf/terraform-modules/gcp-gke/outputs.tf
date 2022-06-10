output "private_endpoint_1" {
  value       = google_container_cluster.gke.private_cluster_config[0].private_endpoint
  description = "Master Private Endpoint"
}

output "gcp_peering" {
  value       = google_container_cluster.gke.private_cluster_config[0].peering_name
  description = "GCP peering from control plane (Google VPC) to project VPC"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.gke.name
  description = "GKE Cluster Name"
}

output "region" {
  value       = google_container_cluster.gke.location
  description = "GKE Cluster Region"
}

output "kms_crypto_key" {
  value       = google_kms_crypto_key.crypto_key.name
  description = "Vault Unsealer Crypto Key"
}
