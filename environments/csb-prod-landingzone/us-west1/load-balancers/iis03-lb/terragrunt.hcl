include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/internal-tcp-lb"
}

dependency "ig" {
  config_path = "../../instance-groups/iis03-ig"

  mock_outputs = {
    self_link = "projects/mock-project/zones/us-central1-a/instanceGroups/iis03-ig"
  }
}

inputs = {
  name              = "ingress-iis03"
  region            = "us-west1"
  health_check_port = 8090
  ports             = ["8090"]

  backend_groups = [
    {
      group = dependency.ig.outputs.self_link
    }
  ]
}
