#!/bin/bash
PROJECT="csb-prod-bkaya"
REGION="northamerica-south1"

echo "Importing External VPN Gateway..."
terragrunt import 'google_compute_external_vpn_gateway.external_gateway' "projects/$PROJECT/global/externalVpnGateways/csb-kio-vpn-ha-gw"

echo "Importing HA VPN Gateway..."
terragrunt import 'google_compute_ha_vpn_gateway.ha_gateway' "projects/$PROJECT/regions/$REGION/vpnGateways/vpn-kio-bkaya-ha"

echo "Importing Cloud Router..."
terragrunt import 'google_compute_router.router' "projects/$PROJECT/regions/$REGION/routers/vpn-kio-bkaya-ha-cloud-router"

echo "Importing Tunnels..."
terragrunt import 'google_compute_vpn_tunnel.tunnels["0"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-tunnel-0"
terragrunt import 'google_compute_vpn_tunnel.tunnels["1"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-tunnel-1"

echo "Importing Router Interfaces..."
terragrunt import 'google_compute_router_interface.router_interface["0"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-cloud-router/if-vpn-kio-bkaya-ha"
terragrunt import 'google_compute_router_interface.router_interface["1"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-cloud-router/if-vpn-kio-bkaya-ha-bgp-1"

echo "Importing Router Peers..."
terragrunt import 'google_compute_router_peer.router_peer["0"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-cloud-router/vpn-kio-bkaya-ha"
terragrunt import 'google_compute_router_peer.router_peer["1"]' "$PROJECT/$REGION/vpn-kio-bkaya-ha-cloud-router/vpn-kio-bkaya-ha-bgp-1"

echo "Done!"
