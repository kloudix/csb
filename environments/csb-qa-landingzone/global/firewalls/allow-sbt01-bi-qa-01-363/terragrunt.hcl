include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name        = "allow-sbt01-bi-qa-01-363"
  
  # Si el nombre de tu red es diferente, descomenta y edita la siguiente línea:
  # network   = "vpc-csb-qa-landingzone"

  # Origen: IP del ESB de QA y de Prom
  source_ranges = [
    "10.27.102.5/32", 
    "10.27.102.6/32"
  ]

  # Destino: Aplicamos la regla a ambas VMs usando sus nombres como Network Tags
  target_tags = [
    "csbgcpesbt01",
    "csb-01-gcp-dac-prom-qa-01"
  ]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["363"]
    }
  ]
}
