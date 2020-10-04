# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "gcp_project" {
    description = "The name of the GCP Project where all resources will be launched."
    type = string
}

variable "gcp_region" {
    description = "The name of the GCP Region where all resources will be launched."
    type = string
}

variable "gcp_zone" {
    description = "The name of the GCP Zone where all resources will be launched."
    type = string
}

variable "gcp_network" {
    description = "The name of the GCP Network where all resources will be linked."
    type = string
}

variable "gcp_subnetwork" {
    description = "The name of the GCP Sub-network where all resources will be linked."
    type = string
}

variable "name" {
    description = "The name of bastion host machine"
    type = string
    default = "bastion"
}

variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type = list(string)
  default     = []
}

variable "machine_type" {
    description = "The name of machine type which is used to launch the resource."
    type = string
    default = "g1-small"
}

variable "disk_size_gb" {
    description = "The number of disk size to launch the machine."
    type = number
    default = 10
}

variable "image_family" {
    description = "The name of GCP machine imago to launch the machine."
    type = string
    default = "debian-9-stretch-v20200805"
}

variable "scopes" {
  description = "List of scopes to attach to the bastion host"
  type = list(string)
  default     = ["cloud-platform"]
}

variable "preemptible" {
  description = "Enable preemptible for machine"
  type = bool
  default = false
}

variable "network_ip_address" {
    description = "Set the network IP address for bastion host by manually, or it will be created automatically."
    type = string
    default = ""
}

variable "service_account_roles" {
  description = "List of IAM roles to assign to the service account."
  type = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/compute.osLogin",
  ]
}

variable "network_tags" {
    description = "The list of network tags will be used for machine to open firewall."
    type = list(string)
    default = ["bastion"]
}

variable "network_target_tags" {
    description = "The list of network tags will be used to open firewall allow access from bastion to destination hosts."
    type = list(string)
    default = ["bastion-access"]
}

variable "network_target_ports" {
    description = "The list of network ports will be used to open firewall allow access from bastion to destination hosts."
    type = list(string)
    default = ["22", "80", "443", "8888"]
}

variable "additional_iap_ports" {
  description = "A list of additional ports/ranges to open access to on the instances from IAP."
  type        = list(string)
  default     = []
}

variable "startup_script" {
  description = "Render a startup script with a template."
  type = string
  default     = ""
}