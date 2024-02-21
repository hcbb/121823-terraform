<<<<<<< HEAD
resource "azurerm_public_ip" "public_ip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.sku

  zones = var.zones

  tags = merge(var.tags, {
    type = "ip"
  })
}

=======
resource "azurerm_public_ip" "public_ip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.sku

  zones = var.zones

  tags = merge(var.tags, {
    type = "ip"
  })
}

>>>>>>> 340c22c (hb-test-interview)
