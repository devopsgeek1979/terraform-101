###############################################################################
# infra-vsphere-port-groups  |  main.tf
###############################################################################

data "vsphere_datacenter" "this" {
  name = var.datacenter
}

data "vsphere_host" "this" {
  name          = var.esxi_host
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_distributed_virtual_switch" "this" {
  name          = var.dvs_name
  datacenter_id = data.vsphere_datacenter.this.id
}

resource "vsphere_distributed_port_group" "management" {
  name                            = "infra-vsphere-pg-mgmt-${var.environment}"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.this.id
  vlan_id                         = var.mgmt_vlan_id
  type                            = "earlyBinding"
  active_uplinks                  = ["uplink1"]
  standby_uplinks                 = ["uplink2"]
  allow_promiscuous               = false
  allow_mac_changes               = false
  allow_forged_transmits          = false
}

resource "vsphere_distributed_port_group" "workload" {
  name                            = "infra-vsphere-pg-workload-${var.environment}"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.this.id
  vlan_id                         = var.workload_vlan_id
  type                            = "earlyBinding"
  active_uplinks                  = ["uplink1"]
  standby_uplinks                 = ["uplink2"]
  allow_promiscuous               = false
  allow_mac_changes               = false
  allow_forged_transmits          = false
}

resource "vsphere_distributed_port_group" "storage" {
  name                            = "infra-vsphere-pg-storage-${var.environment}"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.this.id
  vlan_id                         = var.storage_vlan_id
  type                            = "earlyBinding"
  active_uplinks                  = ["uplink1", "uplink2"]
  allow_promiscuous               = false
  allow_mac_changes               = false
  allow_forged_transmits          = false
}
