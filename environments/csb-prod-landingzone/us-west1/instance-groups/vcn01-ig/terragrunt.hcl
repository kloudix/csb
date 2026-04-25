include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/unmanaged-ig"
}

inputs = {
  name    = "vcn01-ig"
  zone    = "us-west1-c" # Corregido a formato de GCP

  # Pasa el self_link de la instancia vcn01
  instances = [
    "projects/csb-prod-landingzone/zones/us-west1-c/instances/csbgcpvcn01"
  ]
}
