include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/classic-vpn"
}

inputs = {
  project_id    = "csb-prod-landingzone"
  region        = "us-west1"
  name          = "vpn-samara-landing"
  ike_version   = 1

  peer_ip       = "201.163.187.116"
  shared_secret = get_env("TF_VAR_VPN_SECRET_1", "dummy-secret-1")

  local_traffic_selector = [
    "10.18.0.9/32",
    "10.18.0.19/32",
    "10.18.0.34/32",
    "10.18.0.50/32",
    "10.18.0.79/32",
    "10.18.0.83/32",
    "10.18.0.89/32",
    "10.18.0.93/32",
    "10.18.0.98/32",
    "10.18.0.106/32",
    "10.18.0.131/32",
    "10.18.0.132/32",
    "10.18.0.141/32",
    "10.18.0.142/32",
    "10.18.0.144/32",
    "10.18.0.148/32",
    "10.18.0.158/32"
  ]


  remote_traffic_selector = [
    "10.129.40.145/32",
    "10.129.40.146/32"
  ]
}
