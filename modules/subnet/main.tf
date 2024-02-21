<<<<<<< HEAD
resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.net_name
  address_prefixes     = var.add_prefixes
  #private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  #private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegation
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.service_delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "main" {
  count = var.nat_gateway_id != "" ? 1 : 0

  subnet_id      = azurerm_subnet.main.id
  nat_gateway_id = var.nat_gateway_id
}

resource "azurerm_subnet_route_table_association" "main" {
  count = var.route_table_id != "" ? 1 : 0

  subnet_id      = azurerm_subnet.main.id
  route_table_id = var.route_table_id
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count = var.network_security_group_association != "" ? 1 : 0

  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = var.network_security_group_association
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_subnet.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

=======
resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.net_name
  address_prefixes     = var.add_prefixes
  #private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  #private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegation
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.service_delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "main" {
  count = var.nat_gateway_id != "" ? 1 : 0

  subnet_id      = azurerm_subnet.main.id
  nat_gateway_id = var.nat_gateway_id
}

resource "azurerm_subnet_route_table_association" "main" {
  count = var.route_table_id != "" ? 1 : 0

  subnet_id      = azurerm_subnet.main.id
  route_table_id = var.route_table_id
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count = var.network_security_group_association != "" ? 1 : 0

  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = var.network_security_group_association
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_subnet.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

>>>>>>> 340c22c (hb-test-interview)
