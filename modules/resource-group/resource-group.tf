<<<<<<< HEAD
locals {
  my_name  = var.resource_group_name
}

resource "azurerm_resource_group" "main" {
  name     = local.my_name
  location = var.location

  tags       = merge(var.tags, {
  })
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_resource_group.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

=======
locals {
  my_name  = var.resource_group_name
}

resource "azurerm_resource_group" "main" {
  name     = local.my_name
  location = var.location

  tags       = merge(var.tags, {
  })
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = azurerm_resource_group.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

>>>>>>> 340c22c (hb-test-interview)
