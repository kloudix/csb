include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name        = "allow-ad-adst01-tags"
  
  # Origen: Añade aquí los Network Tags de las VMs dentro del mismo proyecto que necesiten acceso al AD
  source_tags = [
    "ad-client-replace-me" # REEMPLAZAR con el Tag real (ej: "csbgcpesbt01")
  ]

  # Destino: La VM del AD de QA
  target_tags = ["csbgcpbdadst01"]

  # Puertos necesarios para Active Directory
  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["53", "88", "135", "139", "389", "445", "464", "636", "3268", "3269", "49152-65535"]
    },
    {
      protocol = "udp"
      ports    = ["53", "88", "123", "389", "464"]
    }
  ]
}
