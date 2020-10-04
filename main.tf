# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

terraform {
    required_version = ">= 0.12"
}

resource "google_service_account" "bastion_host" {
  project      = var.gcp_project
  account_id   = "bastion-host"
  display_name = "Service account for bastion host"
}

resource "google_service_account_iam_binding" "bastion_sa_user" {
  service_account_id = google_service_account.bastion_host.id
  role               = "roles/iam.serviceAccountUser"
  members            = var.members
}

resource "google_project_iam_member" "bastion_sa_bindings" {
  for_each = toset(var.service_account_roles)
  project = var.gcp_project
  role    = each.value
  member  = format("serviceAccount:%s", google_service_account.bastion_host.email)
}

resource "google_compute_instance" "bastion_host" {
  name = var.name
  project = var.gcp_project
  machine_type = var.machine_type
  zone = var.gcp_zone
  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.image_family
      size = var.disk_size_gb
    }
  }

  network_interface {
    network = data.google_compute_network.network.self_link
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link
    network_ip = var.network_ip_address
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = var.preemptible
  }

  service_account {
    email = google_service_account.bastion_host.email
    scopes = var.scopes
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = var.startup_script
}

data "google_compute_network" "network" {
  name = var.gcp_network
}

data "google_compute_subnetwork" "subnetwork" {
  name = var.gcp_subnetwork
  region = var.gcp_region
}