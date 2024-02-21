<<<<<<< HEAD
resource "azurerm_virtual_network" "main" {
  name                = var.net_name
  address_space       = [var.net_add_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = merge(var.tags, {
    type = "network"
  })
}

resource "azurerm_virtual_network_peering" "main" {
  count                     = var.peering_name != "" ? 1 : 0
  name                      = var.peering_name
  allow_forwarded_traffic   = var.peering_allow_forwarded_traffic
  allow_gateway_transit     = var.peering_allow_gateway_transit
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.remote_virtual_network_id
  use_remote_gateways       = var.peering_use_remote_gateways
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_virtual_network.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

=======
resource "azurerm_virtual_network" "main" {
  name                = var.net_name
  address_space       = var.net_add_space
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = merge(var.tags, {
    type = "network"
  })
}

resource "azurerm_virtual_network_peering" "main" {
  count                     = var.peering_name != "" ? 1 : 0
  name                      = var.peering_name
  allow_forwarded_traffic   = var.peering_allow_forwarded_traffic
  allow_gateway_transit     = var.peering_allow_gateway_transit
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.remote_virtual_network_id
  use_remote_gateways       = var.peering_use_remote_gateways
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_virtual_network.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

>>>>>>> 340c22c (hb-test-interview)
