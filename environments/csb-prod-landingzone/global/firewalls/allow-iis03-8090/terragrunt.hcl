include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name = "allow-iis03-8090"

  # Origen: IP del cliente autorizado
  source_ranges = [
    "10.128.253.2/32"
  ]

  # Destino: la VM csbgcpiis03
  target_tags = ["csbgcpiis03"]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["8090"]
    }
  ]
}
