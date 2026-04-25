include "root" {
  path = find_in_parent_folders()
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "csb-prod-bkaya"
  region  = "northamerica-south1"
}
EOF
}

terraform {
  source = "../../../../../modules/ha-vpn"
}

inputs = {
  project_id   = "csb-prod-bkaya"
  region       = "northamerica-south1"
  network      = "https://www.googleapis.com/compute/v1/projects/csb-prod-bkaya/global/networks/vpc-csb-prod-bkaya"
  ha_vpn_name  = "vpn-kio-bkaya-ha"
  ext_vpn_name = "csb-kio-vpn-ha-gw"
  router_name  = "vpn-kio-bkaya-ha-cloud-router"
  
  peer_ips = [
    "201.175.46.70",
    "201.175.46.68"
  ]

  # Se leen desde las variables de entorno de tu máquina local por seguridad.
  # Exporta estas variables en tu terminal antes de ejecutar terragrunt:
  # export TF_VAR_VPN_SECRET_0="tu_secreto_0"
  # export TF_VAR_VPN_SECRET_1="tu_secreto_1"
  shared_secrets = [
    get_env("TF_VAR_VPN_SECRET_0", "dummy-secret-0"),
    get_env("TF_VAR_VPN_SECRET_1", "dummy-secret-1")
  ]

  bgp_asn = 65010
  bgp_custom_advertised_ip_ranges = [
    "10.86.14.2/32",
    "10.86.14.4/32",
    "10.86.14.5/32"
  ]

  tunnels = {
    "0" = {
      tunnel_name               = "vpn-kio-bkaya-ha-tunnel-0"
      peer_external_gw_iface    = 0
      vpn_gateway_interface     = 0
      router_interface_name     = "if-vpn-kio-bkaya-ha"
      router_interface_ip       = "169.254.43.9/30"
      peer_name                 = "vpn-kio-bkaya-ha"
      peer_ip_address           = "169.254.43.10"
      peer_asn                  = 65020
      advertised_route_priority = null
    },
    "1" = {
      tunnel_name               = "vpn-kio-bkaya-ha-tunnel-1"
      peer_external_gw_iface    = 1
      vpn_gateway_interface     = 1
      router_interface_name     = "if-vpn-kio-bkaya-ha-bgp-1"
      router_interface_ip       = "169.254.15.137/30"
      peer_name                 = "vpn-kio-bkaya-ha-bgp-1"
      peer_ip_address           = "169.254.15.138"
      peer_asn                  = 65020
      advertised_route_priority = 100
    }
  }
}
