provider "azurerm" {
  features {}
  subscription_id = "e02004f7-fd90-4fb3-9009-64201ae8dc5f"

}

module "main" {
source = "./modules/virtual_machine"
name=var.name
location=var.location
suffixname = var.suffixname
}


