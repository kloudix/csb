include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/firewall"
}

inputs = {
  name    = "allow-vcn01-lb-8080-8081"
  
  # Rango origen de GCP para Health Checks: 130.211.0.0/22 y 35.191.0.0/16
  # Rango de la subred desde donde venga el trafico de las otras partes
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
    # Agrega aqui tu bloque de IP origen para el trafico (ej. 10.0.0.0/8)
    "10.0.0.0/8" 
  ]
  
  # Las etiquetas destino asumiendo que tu VM "csbgcpvcn01" tiene ese tag
  # target_tags = ["vcn01-server"] 

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["8080", "8081", "8082"]
    },
    {
      protocol = "icmp"
      ports    = []
    }
  ]
}
