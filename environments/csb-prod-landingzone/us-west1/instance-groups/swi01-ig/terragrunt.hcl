include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/unmanaged-ig"
}

inputs = {
  name = "swi01-ig"
  zone = "us-west1-c"

  instances = [
    "projects/csb-prod-landingzone/zones/us-west1-c/instances/csbgcpswi01"
  ]
}
