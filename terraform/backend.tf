terraform {
  backend "azurerm" {
    storage_account_name = "$sample-storage"
    container_name = "$sample-container"
    key = "terraform.tfstate"
  }
}