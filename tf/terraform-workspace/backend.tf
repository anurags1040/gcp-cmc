terraform {
  backend "gcs" {
    bucket = "cmc-cad"
    prefix = "terraform/state"
  }
}
