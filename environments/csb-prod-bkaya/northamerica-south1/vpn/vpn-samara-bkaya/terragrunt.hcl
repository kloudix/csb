include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/classic-vpn"
}

inputs = {
  project_id    = "csb-prod-bkaya"
  region        = "northamerica-south1"
  network       = "vpc-csb-prod-bkaya"
  name          = "vpn-samara-bkaya"
  peer_ip       = "201.163.187.116"
  shared_secret = get_env("TF_VAR_VPN_SECRET_0", "dummy-secret-0")

  local_traffic_selector = [
    "10.86.14.2/32",
    "10.86.14.4/32",
    "10.86.14.5/32"
  ]

  remote_traffic_selector = [
    "10.129.40.145/32",
    "10.129.40.146/32"
  ]

}
