output "forwarding_rule_id" {
  description = "The ID of the forwarding rule"
  value       = google_compute_forwarding_rule.default.id
}

output "forwarding_rule_ip" {
  description = "The internal IP address assigned to the forwarding rule"
  value       = google_compute_forwarding_rule.default.ip_address
}

output "backend_service_id" {
  description = "The ID of the backend service"
  value       = google_compute_region_backend_service.default.id
}
