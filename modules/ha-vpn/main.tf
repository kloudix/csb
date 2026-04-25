resource "google_compute_external_vpn_gateway" "external_gateway" {
  name            = var.ext_vpn_name
  redundancy_type = "TWO_IPS_REDUNDANCY"
  description     = ""
  project         = var.project_id
  
  dynamic "interface" {
    for_each = var.peer_ips
    content {
      id         = interface.key
      ip_address = interface.value
    }
  }
}

resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  name    = var.ha_vpn_name
  network = var.network
  region  = var.region
  project = var.project_id
}

resource "google_compute_router" "router" {
  name    = var.router_name
  network = var.network
  region  = var.region
  project = var.project_id

  bgp {
    asn                = var.bgp_asn
    advertise_mode     = length(var.bgp_custom_advertised_ip_ranges) > 0 ? "CUSTOM" : "DEFAULT"
    keepalive_interval = 20
    
    dynamic "advertised_ip_ranges" {
      for_each = var.bgp_custom_advertised_ip_ranges
      content {
        range = advertised_ip_ranges.value
      }
    }
  }
}

resource "google_compute_vpn_tunnel" "tunnels" {
  for_each                        = var.tunnels
  name                            = each.value.tunnel_name
  region                          = var.region
  project                         = var.project_id
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.id
  peer_external_gateway_interface = each.value.peer_external_gw_iface
  shared_secret                   = var.shared_secrets[each.key]
  router                          = google_compute_router.router.id
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  ike_version                     = 2
}

resource "google_compute_router_interface" "router_interface" {
  for_each   = var.tunnels
  name       = each.value.router_interface_name
  router     = google_compute_router.router.name
  region     = var.region
  project    = var.project_id
  ip_range   = each.value.router_interface_ip
  vpn_tunnel = google_compute_vpn_tunnel.tunnels[each.key].name
}

resource "google_compute_router_peer" "router_peer" {
  for_each                  = var.tunnels
  name                      = each.value.peer_name
  router                    = google_compute_router.router.name
  region                    = var.region
  project                   = var.project_id
  peer_ip_address           = each.value.peer_ip_address
  peer_asn                  = each.value.peer_asn
  advertised_route_priority = each.value.advertised_route_priority
  interface                 = google_compute_router_interface.router_interface[each.key].name
  bfd {
    min_receive_interval        = 1000
    min_transmit_interval       = 1000
    multiplier                  = 5
    session_initialization_mode = "DISABLED"
  }
}
