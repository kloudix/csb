include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/iap-access"
}

inputs = {
  # Carga automáticamente la lista de usuarios y máquinas desde el archivo vms.yaml
  vms = yamldecode(file("vms.yaml"))
}
