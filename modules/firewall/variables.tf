variable "name" {
  description = "Name of the firewall rule"
  type        = string
}

variable "network" {
  description = "The network self link or name to attach the firewall rule to"
  type        = string
}

variable "source_ranges" {
  description = "A list of source CIDR ranges that this firewall applies to"
  type        = list(string)
  default     = []
}

variable "source_tags" {
  description = "A list of source tags for this firewall"
  type        = list(string)
  default     = null
}

variable "target_tags" {
  description = "A list of target tags for this firewall"
  type        = list(string)
  default     = null
}

variable "allow_rules" {
  description = "List of allow rules"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = []
}
