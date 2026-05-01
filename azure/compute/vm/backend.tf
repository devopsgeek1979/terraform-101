terraform {
  backend "azurerm" {
    resource_group_name  = "REPLACE-TFSTATE-RG"
    storage_account_name = "REPLACETFSTATEACCT"
    container_name       = "tfstate"
    key                  = "compute/vm/terraform.tfstate"
  }
}
