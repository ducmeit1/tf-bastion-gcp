# Provision Bastion on GCP with Terraform

This is terraform module that will help you deploy a bastion host to allow you access to others assets in the private network. Read more at [here](https://cloud.google.com/solutions/connecting-securely).

![bastion](https://cloud.google.com/solutions/images/bastion.png)

This module will will:

- Create a bastion host in your private network/subnet work.
- Enable IAP Tunneling to allow users can access to the bastion host via IAP (uses GSuite).
- Allow you confiure firewall by network tags and network ports.
- Allow you configure service account to secure the bastion.

## Usages

- Create bastion with an existing network/subnetwork:

```hcl
module "bastion" {
    source = "git::git@github.com:ducmeit1/tf-bastion-gcp.git/?ref=master"
    name = "bastion-vm"
    gcp_project = "driven-stage-269911"
    gcp_region = "asia-southeast1"
    gcp_zone = "asia-southeast1-a"
    gcp_network = "shared-network"
    gcp_subnetwork = "shared-subnet"
    machine_type = "n1-standard-1"
    disk_size_gb = 20
    image_family = "ubuntu-1804-lts"
    preemptible = true
}
```

- Create bastion with a new network/subnetwork:

```hcl
module "network" {
    source = "git::git@github.com:ducmeit1/tf-network-gcp.git/?ref=master"
    gcp_project = "driven-stage-269911"
    gcp_region = "asia-southeast1"
    gcp_network = "shared-network"
    gcp_subnetwork = "shared-subnet"
    total_nat_ips = 1
}

module "bastion" {
    source = "git::git@github.com:ducmeit1/tf-bastion-gcp.git/?ref=master"
    name = "bastion-vm"
    gcp_project = "driven-stage-269911"
    gcp_region = "asia-southeast1"
    gcp_zone = "asia-southeast1-a"
    gcp_network = module.network.network_name
    gcp_subnetwork = "module.network.subnetwork_name"
    machine_type = "n1-standard-1"
    disk_size_gb = 20
    image_family = "ubuntu-1804-lts"
    preemptible = true
}
```