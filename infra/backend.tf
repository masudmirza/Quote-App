terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "state"
    key                  = "quoteapp.terraform.tfstate"
  }
}
