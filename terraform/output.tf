output "vm_name" {
  value = azurerm_linux_virtual_machine.main.name
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}