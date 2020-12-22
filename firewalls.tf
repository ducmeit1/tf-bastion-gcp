resource "google_compute_firewall" "allow_from_iap_to_instances" {
  project = var.gcp_project
  name    = format("allow-ssh-from-iap-to-instances-by-%s", var.name)
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = toset(concat(["22"], var.additional_iap_ports))
  }

  # https://cloud.google.com/iap/docs/using-tcp-forwarding#before_you_begin
  # This is the netblock needed to forward to the instances
  source_ranges = ["35.235.240.0/20"]

  target_service_accounts = [google_service_account.bastion_host.email]
}

resource "google_compute_firewall" "allow_ssh_to_bastion" {
  project = var.gcp_project
  name    = format("allow-ssh-to-bastion-%s", var.name)
  network = data.google_compute_network.network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = var.network_tags
}

resource "google_compute_firewall" "allow_connect_from_bastion" {
    project = var.gcp_project
    name = format("allow-connect-from-bastion-%s", var.name)
    network = data.google_compute_network.network.name
    direction = "INGRESS"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = var.network_target_ports
    }
    
    source_tags = var.network_tags
    target_tags = var.network_target_tags
}