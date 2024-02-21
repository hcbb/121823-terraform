provider "azurerm" {
  features {}
}
module "resource-group" {
  source = "./modules/resource-group" 
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
resource "azurerm_route_table" "Candidate_Route_Table" {
  name                = "Healthcare_bluebook_route_table"
  location            = var.location
  resource_group_name = var.resource_group_name

    route {
    name                   = "Internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}
module "network" {
  source = "./modules/network"
  net_name            = var.net_name
  net_add_space       = var.net_add_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}
module "subnet" {
  source = "./modules/subnet"
  subnet_name          = var.subnet_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  net_name             = var.net_name
  add_prefixes         = var.add_prefixes
  route_table_id       = var.route_table_id
  tags                 = var.tags
}
module "public-ip" { 
  source = "./modules/public-ip"
  pip_name            = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = "Standard"
  tags                = var.tags
}

module "vm-linux" {
  source = "./modules/vm-linux"
  vm_name               = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_size               = var.vm_size
  admin_username        = var.admin_username
  image_version         = "latest"
  offer                 = var.offer
  publisher             = var.publisher
  sku                   = "18_04-lts-gen2"
  tags                  = var.tags
  subnet_id             = var.subnet_id
  env                   = "Production"
  public_ip_address     = var.public_ip_address_id
}

module "network-security-group" {
  source                = "./modules/network-security-group"
  name                  = "Hb-nsg"
  location              = var.location
  resource_group_name   = var.resource_group_name 
  security_rules        = var.security_rules
  tags                  = var.tags
}

resource "azurerm_lb" "Hb_load_balancer" {
  name                = "Hb-load-balancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "public-ip-config"
    public_ip_address_id = var.public_ip_address_id
  }
}

resource "azurerm_lb_backend_address_pool" "hb_backend_pool" {
  name            = "hb-backend"
  loadbalancer_id = azurerm_lb.Hb_load_balancer.id
}

resource "azurerm_lb_probe" "hb-probe" {
  name            = "hb-health-probe"
  loadbalancer_id = azurerm_lb.Hb_load_balancer.id
  protocol        = "Http"
  request_path    = "/"
  port            = 80
}

resource "azurerm_lb_rule" "Hb_http_rule" {
  name                           = "Hb-http-rule"
  loadbalancer_id                = azurerm_lb.Hb_load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-ip-config"
  probe_id                       = azurerm_lb_probe.hb-probe.id
  backend_address_pool_ids       = var.backend_address_pools_id 
}

resource "azurerm_cdn_frontdoor_profile" "Hb-Frontdoor" {
  name                     = var.frontdoor_name
  resource_group_name      = var.resource_group_name
  sku_name                 = "Standard_AzureFrontDoor"
  response_timeout_seconds = var.response_timeout_seconds
}
resource "azurerm_cdn_frontdoor_endpoint" "Hb-Frontdoor-Endpoint" {
  name                     = var.frontdoor_endpoint_name 
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.Hb-Frontdoor.id
} 
resource "azurerm_cdn_frontdoor_origin_group" "frontdoor-fe-origin-group" {
  name                     = var.origin_group_name_fe
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.Hb-Frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/health-check"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}
module "storage-account" {
  source = "./modules/storage-account"
  name                  = var.storage_account_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  account_kind          = var.account_kind
  account_replication_type = var.account_replication_type
  tags                  = var.tags
}
resource "azurerm_storage_container" "hb_frontend" {
  name                  = var.container_name
  storage_account_name  = module.storage-account.storage_account_name
  container_access_type = var.container_access_type
}

resource "azurerm_cdn_frontdoor_route" "frontdoor-frontend-route" {
  name                          = var.route_name_fe
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.Hb-Frontdoor-Endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontdoor-fe-origin-group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontdoor-frontend-origin.id]
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  link_to_default_domain = true
  https_redirect_enabled = true
}
resource "azurerm_cdn_frontdoor_origin" "frontdoor-frontend-origin" {
  name                          = var.origin_name_fe
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontdoor-fe-origin-group.id
  enabled                        = true
  host_name                      = var.host_name_fe
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.host_name_fe
  weight                         = 1000
  certificate_name_check_enabled = true
}
#resource "azurerm_cdn_frontdoor_custom_domain" "main" {
#  name                     = each.value.name
#  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.Hb-Frontdoor.id
#  dns_zone_id = each.value.dns_zone_id
#  host_name   = each.value.host_name
#}