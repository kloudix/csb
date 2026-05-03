variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region for the VPN"
  type        = string
}

variable "network" {
  description = "The VPC network name or self_link"
  type        = string
}

variable "name" {
  description = "Base name for the VPN resources"
  type        = string
}

variable "peer_ip" {
  description = "The public IP of the peer VPN gateway"
  type        = string
}

variable "shared_secret" {
  description = "The shared secret for the VPN tunnel"
  type        = string
  sensitive   = true
}

variable "local_traffic_selector" {
  description = "List of local (GCP) CIDR ranges for policy-based VPN"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "remote_traffic_selector" {
  description = "List of remote (On-prem) CIDR ranges for policy-based VPN"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ike_version" {
  description = "IKE version (1 or 2)"
  type        = number
  default     = 2
}

