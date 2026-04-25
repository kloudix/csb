locals {
  # Recolectar todos los usuarios únicos para darles el rol de Viewer a nivel proyecto
  all_users = distinct(flatten([
    for vm in var.vms : concat(vm.ad_users, vm.os_admins, vm.os_users)
  ]))

  # Combinar ad_users, os_admins y os_users para darles acceso al túnel IAP
  tunnel_map = {
    for k, v in var.vms : k => distinct(concat(v.ad_users, v.os_admins, v.os_users))
  }
}

# 1. Project level viewer role (so IAP desktop works)
resource "google_project_iam_member" "compute_viewer" {
  for_each = toset(local.all_users)
  project  = var.project_id
  role     = "roles/compute.viewer"
  member   = each.key
}

# 2. IAP Tunnel Access per VM
resource "google_iap_tunnel_instance_iam_binding" "iap_tunnel" {
  for_each = { for k, v in local.tunnel_map : k => v if length(v) > 0 }
  project  = var.project_id
  zone     = var.vms[each.key].zone
  instance = each.key
  role     = "roles/iap.tunnelResourceAccessor"
  members  = each.value
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
