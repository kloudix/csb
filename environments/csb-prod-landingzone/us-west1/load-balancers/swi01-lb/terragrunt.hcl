include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/internal-tcp-lb"
}

dependency "ig" {
  config_path = "../../instance-groups/swi01-ig"

  mock_outputs = {
    self_link = "projects/mock-project/zones/us-central1-a/instanceGroups/swi01-ig"
  }
}

inputs = {
  name              = "ingress-swi01"
  region            = "us-west1"
  health_check_port = 8080
  ports             = ["80", "443", "8087", "8080", "8081"]

  backend_groups = [
    {
      group = dependency.ig.outputs.self_link
    }
  ]
}
