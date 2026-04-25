# 1. Project level viewer role (so IAP desktop works)
resource "google_project_iam_member" "compute_viewer" {
  for_each = toset(var.viewers)
  project  = var.project_id
  role     = "roles/compute.viewer"
  member   = each.key
}

# 2. IAP Tunnel Access per VM
resource "google_compute_instance_iam_binding" "iap_tunnel" {
  for_each = { for k, v in var.vms : k => v if length(v.tunnel_users) > 0 }
  project       = var.project_id
  zone          = each.value.zone
  instance_name = each.key
  role          = "roles/iap.tunnelResourceAccessor"
  members       = each.value.tunnel_users
}

# 3. OS Admin Login per VM (for Local VMs)
resource "google_compute_instance_iam_binding" "os_admin" {
  for_each = { for k, v in var.vms : k => v if length(v.os_admins) > 0 }
  project       = var.project_id
  zone          = each.value.zone
  instance_name = each.key
  role          = "roles/compute.osAdminLogin"
  members       = each.value.os_admins
}

# 4. OS Standard Login per VM (for Local VMs)
resource "google_compute_instance_iam_binding" "os_user" {
  for_each = { for k, v in var.vms : k => v if length(v.os_users) > 0 }
  project       = var.project_id
  zone          = each.value.zone
  instance_name = each.key
  role          = "roles/compute.osLogin"
  members       = each.value.os_users
}
