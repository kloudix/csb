variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vms" {
  description = "Map of VMs and their corresponding IAP access controls"
  type = map(object({
    zone      = string
    ad_users  = optional(list(string), [])
    os_admins = optional(list(string), [])
    os_users  = optional(list(string), [])
  }))
  default = {}
}
