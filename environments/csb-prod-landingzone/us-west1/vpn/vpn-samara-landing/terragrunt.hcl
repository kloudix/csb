include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/classic-vpn"
}

inputs = {
  project_id    = "csb-prod-landingzone"
  region        = "us-west1"
  network       = "vpc-csb-prod-landingzone"
  name          = "vpn-samara-landing"
  peer_ip       = "201.163.187.116"
  shared_secret = get_env("TF_VAR_VPN_SECRET_1", "dummy-secret-1")

  local_traffic_selector = [
    "10.18.0.19/32",
    "10.18.0.34/32",
    "10.18.0.9/32"
  ]

  remote_traffic_selector = [
    "10.129.40.145/32",
    "10.129.40.146/32"
  ]
}
