variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "viewers" {
  description = "List of users who need to view instances in IAP Desktop"
  type        = list(string)
  default     = []
}

variable "vms" {
  description = "Map of VMs and their corresponding IAP access controls"
  type = map(object({
    zone           = string
    tunnel_users   = list(string)
    os_admins      = list(string)
    os_users       = list(string)
  }))
  default = {}
}
