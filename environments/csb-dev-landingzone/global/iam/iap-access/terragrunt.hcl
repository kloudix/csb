include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/iap-access"
}

inputs = {
  vms = yamldecode(file("vms.yaml"))
}
