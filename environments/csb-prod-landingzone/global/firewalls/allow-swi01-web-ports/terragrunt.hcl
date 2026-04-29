include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name = "allow-swi01-web-ports"

  # Orígenes: Cliente autorizado e Interconnect
  source_ranges = [
    "10.128.253.2/32",
    "192.168.201.102/32"
  ]

  # Destino: la VM csbgcpswi01
  target_tags = ["csbgcpswi01"]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["80", "443", "8080", "8097"]
    },
    {
      protocol = "icmp"
      ports    = []
    }
  ]
}
