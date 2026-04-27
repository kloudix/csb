include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name        = "allow-ad-adst01-ips"
  
  # Origen: Añade aquí las IPs (ej. subredes locales, VPN u otros proyectos) que necesiten acceso al AD
  source_ranges = [
    "127.0.0.1/32" # REEMPLAZAR con IPs reales (ej: "10.27.0.0/16")
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
