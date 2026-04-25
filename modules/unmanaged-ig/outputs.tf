output "self_link" {
  description = "The URI of the created resource."
  value       = google_compute_instance_group.default.self_link
}

output "id" {
  description = "The an identifier for the resource with format projects/{{project}}/zones/{{zone}}/instanceGroups/{{name}}."
  value       = google_compute_instance_group.default.id
}
