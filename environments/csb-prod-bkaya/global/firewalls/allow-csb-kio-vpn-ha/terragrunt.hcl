include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name        = "allow-csb-kio-vpn-ha"
  network     = "vpc-csb-prod-bkaya"

  source_ranges = [
    "172.16.40.200/32",
    "172.16.40.241/32",
    "192.168.210.11/32",
    "192.168.200.202/32", # NUEVA: Añadida según el diagrama
    "169.254.0.0/16"
  ]

  target_tags = [
    "csbgcpbkyiib01p",
    "csbgcpbkyesb02p",
    "csbgcpbkyesb01p"
  ]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["179"]
    },
    {
      protocol = "icmp"
      ports    = []
    }
  ]
}
