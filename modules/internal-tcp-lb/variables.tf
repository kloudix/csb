variable "name" {
  description = "Name for the load balancer and associated resources"
  type        = string
}

variable "region" {
  description = "Region where the load balancer will be deployed"
  type        = string
}

variable "network" {
  description = "The network self link to attach the internal load balancer to"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork self link to attach the internal load balancer to"
  type        = string
}

variable "health_check_port" {
  description = "The port used for the health check"
  type        = number
}

variable "ports" {
  description = "List of ports for the forwarding rule (for INTERNAL it can be a list up to 5 ports)"
  type        = list(string)
}

variable "backend_groups" {
  description = "List of maps containing backend instance group URLs"
  type = list(object({
    group = string
  }))
  default = []
}

variable "ip_address" {
  description = "The internal IP address for the forwarding rule (optional)"
  type        = string
  default     = null
}

