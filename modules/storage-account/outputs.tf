<<<<<<< HEAD
output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_container_name" {
  value = values(azurerm_storage_container.main)[*].name
}

output "primary_connection_string" {
  value = azurerm_storage_account.main.primary_connection_string
}

output "private_link_id" {
  value = try(azurerm_private_endpoint.main[1].id, "")
}

output "primary_blob_host" {
  value = azurerm_storage_account.main.primary_blob_host
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}
=======
output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_container_name" {
  value = values(azurerm_storage_container.main)[*].name
}

output "primary_connection_string" {
  value = azurerm_storage_account.main.primary_connection_string
}

output "private_link_id" {
  value = try(azurerm_private_endpoint.main[1].id, "")
}

output "primary_blob_host" {
  value = azurerm_storage_account.main.primary_blob_host
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}
>>>>>>> 340c22c (hb-test-interview)
