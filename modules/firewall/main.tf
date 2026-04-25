resource "google_compute_firewall" "default" {
  name        = var.name
  network     = var.network
  direction   = "INGRESS"
  
  source_ranges = length(var.source_ranges) > 0 ? var.source_ranges : null
  source_tags   = var.source_tags
  target_tags   = var.target_tags

  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}
