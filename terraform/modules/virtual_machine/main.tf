

/* module file for creating vm_with public id && using inbound-ssh(22) for authentication 
and inbound-http(80) for deployment of webapi */

resource "azurerm_resource_group" "rm" {
name="${var.name}-resource"                     ## Resource-group
location="${var.location}"
}

resource "azurerm_virtual_network" "vn" {
  name = "${var.name}-network"
  address_space = ["10.0.0.0/16"]               ##Virtual Network
  resource_group_name = azurerm_resource_group.rm.name
  location = azurerm_resource_group.rm.location
}

# subnet for private-ip 
resource "azurerm_subnet" "sbnet-internal" {
    resource_group_name = azurerm_resource_group.rm.name
    name = "${var.name}-sbnet-internal"
    address_prefixes = ["10.0.1.0/24"]        ##Subnet 
    virtual_network_name = azurerm_virtual_network.vn.name
}
# subnet for public ip 
resource "azurerm_subnet" "sbnet-external" {
    resource_group_name = azurerm_resource_group.rm.name
    name = "${var.name}-sbnet-external"      ##Subnet
    address_prefixes = ["10.0.2.0/24"]
    virtual_network_name = azurerm_virtual_network.vn.name
}

resource "azurerm_public_ip" "pip" {
    name = "${var.name}-pip"
    location = azurerm_resource_group.rm.location       ##publicIp
    resource_group_name = azurerm_resource_group.rm.name
    allocation_method = "Static"
}
# NetInterface public
resource "azurerm_network_interface" "netint-pip" {
    resource_group_name = azurerm_resource_group.rm.name
    name="${var.name}-netint-pip"
    location = azurerm_resource_group.rm.location
    ip_configuration {
      name = "public"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.sbnet-external.id
      public_ip_address_id = azurerm_public_ip.pip.id
    }  
}

# NetInterface private
resource "azurerm_network_interface" "netint-pvt" {
    resource_group_name = azurerm_resource_group.rm.name
    name="${var.name}-netint-pvt"
    location = azurerm_resource_group.rm.location
    ip_configuration {
      name = "private"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.sbnet-internal.id
    }  
}

# NSG -pub
resource "azurerm_network_security_group" "nsg-pub" {
    name = "${var.name}-nsg-pub"
    location = azurerm_resource_group.rm.location
    resource_group_name = azurerm_resource_group.rm.name
    #for http/https
    security_rule{
    name="http-allow"
    access="Allow"
    direction = "Inbound"
    protocol = "Tcp"
    priority = 200
    source_port_range = "*"
    source_address_prefixes = ["0.0.0.0/0"]
    destination_port_range = "80"
    destination_address_prefix = azurerm_network_interface.netint-pip.private_ip_address
    }
    # for ssh
    security_rule{
    name="ssh-allow"
    access="Allow"
    direction = "Inbound"
    protocol = "Tcp"
    priority = 100
    source_port_range = "*"
    source_address_prefixes = ["0.0.0.0/0"]
    destination_port_range = "22"
    destination_address_prefix = azurerm_network_interface.netint-pip.private_ip_address
    }
}

# NSG -pvt
resource "azurerm_network_security_group" "nsg-pvt" {
    name = "${var.name}-nsg-pvt"
    location = azurerm_resource_group.rm.location
    resource_group_name = azurerm_resource_group.rm.name
    security_rule{
    name="noinbound"
    access="Deny"
    direction = "Inbound"
    protocol = "*"
    priority = 200
    source_port_range = "*"
    source_address_prefixes = ["0.0.0.0/0"]
    destination_port_range = "*"
    destination_address_prefix ="*"
    }
}
#linking nic to nsg --public
resource "azurerm_network_interface_security_group_association" "public" {
    network_interface_id = azurerm_network_interface.netint-pip.id
    network_security_group_id = azurerm_network_security_group.nsg-pub.id
}

#linking nic to nsg --private
resource "azurerm_network_interface_security_group_association" "private" {
    network_interface_id = azurerm_network_interface.netint-pvt.id
    network_security_group_id = azurerm_network_security_group.nsg-pvt.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name="${var.name}-vm${var.suffixname}"
  resource_group_name = azurerm_resource_group.rm.name
  location = azurerm_resource_group.rm.location
  size = "Standard_B1s"
  admin_username = "adminuser"
  disable_password_authentication = true
  network_interface_ids = [ 
    azurerm_network_interface.netint-pip.id,
    azurerm_network_interface.netint-pvt.id,
   ]
   admin_ssh_key {
    username   = "adminuser"  
    public_key = file("~/.ssh/ssh_key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "ubuntu-24_04-lts"
    version = "latest"
    sku = "server"
  }
   os_disk {
     storage_account_type = "Standard_LRS"
     caching = "ReadWrite"
   }
   tags = {
    "Environment" = "LINUX"
    "From"="Terraform"
    "Owner"       = "ZishanHassanKhan"
  }
}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
  [Webserver]
  ${azurerm_public_ip.pip.ip_address} ansible_ssh_user=adminuser ansible_ssh_private_key_file=~/.ssh/ssh_key
  EOT
  filename = "../ansible/inventory.ini"
}