# Root terragrunt.hcl

locals {
  # Automatically extract the project ID from the folder structure: environments/<project_id>/...
  path_parts = split("/", path_relative_to_include())
  project_id = length(local.path_parts) > 1 ? local.path_parts[1] : "default-project"

  # Derived names based on standard conventions
  vpc_name    = "${local.project_id}-vpc"
  subnet_name = "${local.project_id}-subnet"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project_id}"
}
EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "csb-terraform-state-landingzone"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Common inputs passed to all modules automatically
inputs = {
  project_id = local.project_id
  network    = local.vpc_name
  subnetwork = local.subnet_name
}
