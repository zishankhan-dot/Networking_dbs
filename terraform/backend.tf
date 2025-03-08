terraform {
  backend "azurerm" {
    storage_account_name = "${var.name}-storage"
    container_name = "${var.name}-container"
    key = "terraform.tfstate"
  }
}