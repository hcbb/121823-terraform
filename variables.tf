variable "principal_id" {
  type        = string
}
variable "tags" {
  type        = map
}
variable "resource_group_name" {
  type        = string
}
variable "location" {
  type        = string
}
variable "net_name" {
  type        = string
}
variable "net_add_space" {
  type        = list (string)
}
variable "subnet_name" {
  type        = string
}
variable "add_prefixes" {
  type        = list (string)
}
variable "route_table_id" {
  type        = string
}
variable "pip_name" {
  type        = string
}
variable "allocation_method" {
  type        = string
}
variable "domain_name_label" {
  type        = string
}

variable "vm_name" {
  type        = string
}
variable "vm_size" {
  type        = string
}
#variable "network_interface_ids" {
#  type        = string
#}
variable "admin_username" {
  type        = string
}
variable "offer" {
  type        = string
}
variable "publisher" {
  type        = string
}
variable "subnet_id" {
  type        = string
}
variable "security_rules" {
  description = "List of security rule attributes"
  type = list(object({
    name                       = string
    description                = optional(string)
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    destination_port_ranges    = optional(list(string))
    source_address_prefix      = string
    source_address_prefixes    = list(string)
    destination_address_prefix = string
    destination_address_prefixes = optional(list(string))
  }))
  default = [
    {
      name                       = ""
      description                = ""
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = ""
      destination_port_ranges    = []
      source_address_prefix      = ""
      source_address_prefixes    = []
      destination_address_prefix = ""
      destination_address_prefixes = []
    }
  ]
}
variable "public_ip_address_id" {
  type        = string
}
variable "backend_address_pools_id" {
  type        = list
}
variable "frontdoor_name" {
  type        = string
}
variable "response_timeout_seconds" {
  type        = number
}
variable "frontdoor_endpoint_name" {
  type        = string
}
variable "origin_group_name_fe" {
  type        = string
}
variable "origin_name_fe" {
  type        = string
}
variable "route_name_fe" {
  type        = string
}
#variable "frontdoor_custom_domain_ids" {
#  type        = list
#}
variable "storage_account_name" {
  type        = string
}
variable "account_replication_type" {
  type        = string
}
variable "account_kind" {
  type        = string
}
variable "host_name_fe" {
  type        = string
}
variable "container_name" {
  type        = string
}
variable "container_access_type" {
  type        = string
}