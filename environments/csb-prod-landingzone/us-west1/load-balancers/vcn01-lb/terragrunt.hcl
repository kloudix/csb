include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/internal-tcp-lb"
}

dependency "ig" {
  config_path = "../../instance-groups/vcn01-ig"
  
  mock_outputs = {
    self_link = "projects/mock-project/zones/us-central1-a/instanceGroups/vcn01-ig"
  }
}

inputs = {
  name              = "ingress-vcn01"
  region            = "us-west1"
  health_check_port = 8080
  ports             = ["8080", "8081", "8082"]
  ip_address        = "10.18.0.181"

  backend_groups = [
    {
      group = dependency.ig.outputs.self_link
    }
  ]
}

