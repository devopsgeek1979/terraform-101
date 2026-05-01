###############################################################################
# infra-vsphere-vm  |  main.tf
###############################################################################

data "vsphere_datacenter" "this" { name = var.datacenter }

data "vsphere_datastore" "this" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_compute_cluster" "this" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_network" "this" {
  name          = var.port_group_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.this.id
}

resource "vsphere_virtual_machine" "this" {
  count            = var.instance_count
  name             = "infra-vsphere-vm-${var.environment}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.this.resource_pool_id
  datastore_id     = data.vsphere_datastore.this.id
  num_cpus         = var.num_cpus
  memory           = var.memory_mb
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  firmware         = "efi"

  network_interface {
    network_id   = data.vsphere_network.this.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.disk_size_gb
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "infra-vsphere-vm-${var.environment}-${count.index + 1}"
        domain    = var.domain
      }
      network_interface {}
    }
  }

  lifecycle { ignore_changes = [clone[0].template_uuid] }
}
