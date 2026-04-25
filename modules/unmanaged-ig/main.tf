resource "google_compute_instance_group" "default" {
  name        = var.name
  description = "Unmanaged instance group managed by Terraform"
  zone        = var.zone

  instances = var.instances
}
