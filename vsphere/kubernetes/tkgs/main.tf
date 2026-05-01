###############################################################################
# infra-vsphere-tkgs  |  main.tf
# Tanzu Kubernetes Grid Supervisor Namespace + TKC cluster
###############################################################################

data "vsphere_datacenter" "this" { name = var.datacenter }

data "vsphere_compute_cluster" "this" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.this.id
}

# Supervisor Namespace
resource "vsphere_namespace" "this" {
  name    = "infra-vsphere-tkgs-ns-${var.environment}"
  cluster = data.vsphere_compute_cluster.this.id

  storage_spec {
    policy = var.storage_policy
  }
}

# Tanzu Kubernetes Cluster (TKC) via kubectl/tanzu provider
# NOTE: Full TKC provisioning requires the vmware/tanzu provider or kubectl_manifest.
# Below is a stub showing the supervisor namespace and the TKC YAML manifest path.
resource "vsphere_supervisor" "this" {
  cluster    = data.vsphere_compute_cluster.this.id
  storage_policy = var.storage_policy

  management_network {
    network          = var.management_network
    starting_address = var.mgmt_start_ip
    subnet_mask      = var.mgmt_subnet_mask
    gateway          = var.mgmt_gateway
    dns_servers      = var.dns_servers
  }

  ingress_cidr    = var.ingress_cidr
  egress_cidr     = var.egress_cidr
  pod_cidr        = var.pod_cidr
  service_cidr    = var.service_cidr
  search_domains  = var.search_domains
  dns_search_domains = var.search_domains

  namespace_subnet {
    namespace = vsphere_namespace.this.name
    subnet    = var.namespace_subnet
  }
}
