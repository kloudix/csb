include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/iap-access"
}

inputs = {
  # Agrega aquí los correos de quienes usan IAP Desktop en csb-prod-bkaya
  viewers = [
    # "user:tu-correo@csb.com"
  ]

  # Configura los accesos VM por VM
  vms = {
    # Ejemplo de máquina en dominio (AD)
    # "vm-ad-01" = {
    #   zone         = "northamerica-south1-a"
    #   tunnel_users = ["user:tu-correo@csb.com"]
    #   os_admins    = []
    #   os_users     = []
    # },

    # Ejemplo de máquina local (OS Login)
    # "vm-local-01" = {
    #   zone         = "northamerica-south1-a"
    #   tunnel_users = ["user:tu-correo@csb.com", "user:monitoreo@csb.com"]
    #   os_admins    = ["user:tu-correo@csb.com"]
    #   os_users     = ["user:monitoreo@csb.com"]
    # }
  }
}
