<<<<<<< HEAD
#Required
variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

#Optional
variable "prefix" {
  default = "nsg-"
}
variable "name" {}
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
      priority                   = 9999
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = ""
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
=======
#Required
variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

#Optional
variable "prefix" {
  default = "nsg-"
}
variable "name" {}
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
      priority                   = 9999
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = ""
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
>>>>>>> 340c22c (hb-test-interview)
