resource "google_compute_region_health_check" "default" {
  name   = "${var.name}-hc"
  region = var.region

  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "${var.name}-backend"
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_region_health_check.default.id]
  network               = var.network

  dynamic "backend" {
    for_each = var.backend_groups
    content {
      group          = backend.value["group"]
      balancing_mode = "CONNECTION"
    }
  }
}

resource "google_compute_forwarding_rule" "default" {
  name                  = var.name
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.id
  ports                 = var.ports
  subnetwork            = var.subnetwork
  network               = var.network
  ip_address            = var.ip_address
}

