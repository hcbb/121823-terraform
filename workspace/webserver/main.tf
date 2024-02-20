module "vm" {
  source = "../../modules/vm-linux"

  resource_group_name       = var.resource_group_name
  location                  = var.location
  vm_name                   = "ky-project"
  vm_size                   = "Standard_DS1_v2"
  subnet_id                 = module.subnet.subnet_id
  admin_username            = "adminuser"
  use_nsg                   = true
  network_security_group_id = module.nsg.network_security_group_id
  publisher                 = "Canonical"
  offer                     = "UbuntuSever"
  sku                       = "22_04-lts"
  image_version             = "latest"
  tags                      = var.tags
}


module "subnet" {
  source = "../../modules/subnet"

  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_name         = "subnet-west-us"
  net_name            = "vnet-west-us"
  route_table_id      = azurerm_route_table.example.id
  add_prefixes        = ["10.0.1.0/24"]
  tags                = var.tags
}

module "nsg" {
  source = "../../modules/network-security-group"

  name                = "nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rules      = [
    {
      name                       = "inbound-http"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "inbound-https"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
  tags = var.tags
}

module "lb" {
  source = "../../modules/load-balancer"

  name                  = "lb"
  location              = var.location
  resource_group_name   = var.resource_group_name
  backend_address_pools = {
    name = "backend-pool"
  }
  pool_associations = {
    network_interface_id  = "${module.vm.vm_primary_interface_id}"
    ip_configuration_name = "ip-name"
  }
  probes = {
    name = "lb-probe"
    port = 80
  }
  rules = [
    {
      name          = "lb-rule-http"
      protocol      = "tcp"
      frontend_port = 80
      backend_port  = 80
    },
    {
      name          = "lb-rule-https"
      protocol      = "tcp"
      frontend_port = 443
      backend_port  = 80
    }
  ]
  frontend_ip_configurations = {
    name      = "publicIP"
    subnet_id = module.subnet.subnet_id
    public_ip = azurerm_public_ip.lb_public_ip.name
  }
  tags = var.tags
}

resource "azurerm_route_table" "example" {
  name                = "example-routetable"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/24"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = "0.0.0.0"
  }
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}