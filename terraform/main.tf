provider "azurerm" {
  features {}
}

module "main" {
source = "/modules/virtual_machine"

name="examplerun"
location="UK south"
}

