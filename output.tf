output "service_account" {
  description = "The email for the service account created for the bastion host"
  value       = google_service_account.bastion_host.email
}

output "hostname" {
  description = "Host name of the bastion"
  value       = var.name
}

output "ip_address" {
  description = "Internal IP address of the bastion host"
  value       = google_compute_instance.bastion_host.network_interface[0].network_ip
}

output "self_link" {
  description = "Self link of the bastion host"
  value       = google_compute_instance.bastion_host.self_link
}