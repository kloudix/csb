variable "name" {
  description = "Name of the instance group"
  type        = string
}

variable "zone" {
  description = "The zone where the instance group will be created"
  type        = string
}

variable "network" {
  description = "The self_link or name of the network"
  type        = string
}

variable "instances" {
  description = "List of instances (self_links) to add to the unmanaged instance group"
  type        = list(string)
  default     = []
}
