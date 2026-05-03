resource "google_compute_vpn_gateway" "target_gateway" {
  name    = var.name
  network = var.network
  region  = var.region
  project = var.project_id
}

resource "google_compute_address" "vpn_static_ip" {
  name    = "${var.name}-ip"
  region  = var.region
  project = var.project_id
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "${var.name}-fr-esp"
  region      = var.region
  project     = var.project_id
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  ip_protocol = "ESP"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "${var.name}-fr-udp500"
  region      = var.region
  project     = var.project_id
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  ip_protocol = "UDP"
  port_range  = "500"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "${var.name}-fr-udp4500"
  region      = var.region
  project     = var.project_id
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  ip_protocol = "UDP"
  port_range  = "4500"
}

resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "${var.name}-tunnel"
  region             = var.region
  project            = var.project_id
  target_vpn_gateway = google_compute_vpn_gateway.target_gateway.id
  shared_secret      = var.shared_secret
  peer_ip            = var.peer_ip

  local_traffic_selector  = var.local_traffic_selector
  remote_traffic_selector = var.remote_traffic_selector

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_route" "route" {
  count       = length(var.remote_traffic_selector)
  name        = "${var.name}-route-${count.index}"
  project     = var.project_id
  network     = var.network
  dest_range  = var.remote_traffic_selector[count.index]
  priority    = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel.id
}

output "vpn_ip" {
  value = google_compute_address.vpn_static_ip.address
}
