variable "location" {}
variable "resource_group_name" {}
variable "name" {}
variable "sku" {
  default = "Standard"
}
variable "frontend_ip_configurations" {
  description = "List of front end ip configurations."
  type        = map(object({
    name                 = string
    public_ip_address_id = string
    subnet_id            = string
  }))
}
variable "backend_address_pools" {
  type = map(object({
    name = string
  }))
}
variable "probes" {
  type = map(object({
    name = string
    port = number
  }))
}
variable "pool_associations" {
  type = map(object({
    pool_id               = string
    network_interface_id  = string
    ip_configuration_name = string
  }))
}
variable "rules" {
  type = map(object({
    name                           = string
    protocol                       = string
    probe_id                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    backend_address_pool_ids       = string
  }))
}
variable "tags" {}

