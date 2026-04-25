variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region for the VPN"
  type        = string
}

variable "network" {
  description = "The VPC network"
  type        = string
}

variable "ha_vpn_name" {
  description = "The HA VPN gateway name"
  type        = string
}

variable "ext_vpn_name" {
  description = "The external VPN gateway name"
  type        = string
}

variable "router_name" {
  description = "The cloud router name"
  type        = string
}

variable "peer_ips" {
  description = "The IPs of the external VPN gateway"
  type        = list(string)
}

variable "shared_secrets" {
  description = "The shared secrets for the VPN tunnels"
  type        = list(string)
  sensitive   = true
}

variable "bgp_asn" {
  description = "The local BGP ASN"
  type        = number
}

variable "bgp_custom_advertised_ip_ranges" {
  description = "The IP ranges to advertise via BGP"
  type        = list(string)
  default     = []
}

variable "tunnels" {
  description = "Configuration for tunnels, interfaces, and peers"
  type = map(object({
    tunnel_name              = string
    peer_external_gw_iface   = number
    vpn_gateway_interface    = number
    router_interface_name    = string
    router_interface_ip      = string
    peer_name                = string
    peer_ip_address          = string
    peer_asn                 = number
    advertised_route_priority = optional(number)
  }))
}
