include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name = "allow-gia01-80-443-8080"

  # Origen: IP del cliente autorizado
  source_ranges = [
    "10.128.253.2/32"
  ]

  # Destino: la VM csbgcpgia01
  target_tags = ["csbgcpgia01"]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["80", "443", "8080"]
    }
  ]
}
