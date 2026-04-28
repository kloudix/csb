include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/unmanaged-ig"
}

inputs = {
  name = "iis03-ig"
  zone = "us-west1-c"

  instances = [
    "projects/csb-prod-landingzone/zones/us-west1-c/instances/csbgcpiis03"
  ]
}
