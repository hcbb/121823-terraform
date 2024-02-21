<<<<<<< HEAD
output "vm_name" {
  value = azurerm_virtual_machine.main.name
}

output "vm_primary_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

output "vm_primary_interface_id" {
  value = azurerm_network_interface.main.id
}

=======
output "vm_name" {
  value = azurerm_virtual_machine.main.name
}

output "vm_primary_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

output "vm_primary_interface_id" {
  value = azurerm_network_interface.main.id
}

>>>>>>> 340c22c (hb-test-interview)
