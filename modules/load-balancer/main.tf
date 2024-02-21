<<<<<<< HEAD
resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
      subnet_id            = frontend_ip_configuration.value.subnet_id
    }
  }

  tags = merge(var.tags, {
    type = "load balancer"
  })
}

resource "azurerm_lb_backend_address_pool" "main" {
  for_each = var.backend_address_pools

  name            = each.value.name
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  for_each = var.probes

  loadbalancer_id = azurerm_lb.main.id
  name            = each.value.name
  port            = each.value.port
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  for_each = var.pool_associations

  backend_address_pool_id = azurerm_lb_backend_address_pool.main[each.value.pool_id].id
  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
}

resource "azurerm_lb_rule" "main" {
  for_each = var.rules

  loadbalancer_id                = azurerm_lb.main.id
  name                           = each.value.name
  protocol                       = each.value.protocol
  probe_id                       = azurerm_lb_probe.main[each.value.probe_id].id
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[each.value.frontend_ip_configuration_name].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main[each.value.backend_address_pool_ids].id]
}

=======
resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
      subnet_id            = frontend_ip_configuration.value.subnet_id
    }
  }

  tags = merge(var.tags, {
    type = "load balancer"
  })
}

resource "azurerm_lb_backend_address_pool" "main" {
  for_each = var.backend_address_pools

  name            = each.value.name
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  for_each = var.probes

  loadbalancer_id = azurerm_lb.main.id
  name            = each.value.name
  port            = each.value.port
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  for_each = var.pool_associations

  backend_address_pool_id = azurerm_lb_backend_address_pool.main[each.value.pool_id].id
  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
}

resource "azurerm_lb_rule" "main" {
  for_each = var.rules

  loadbalancer_id                = azurerm_lb.main.id
  name                           = each.value.name
  protocol                       = each.value.protocol
  probe_id                       = azurerm_lb_probe.main[each.value.probe_id].id
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[each.value.frontend_ip_configuration_name].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main[each.value.backend_address_pool_ids].id]
}

>>>>>>> 340c22c (hb-test-interview)
