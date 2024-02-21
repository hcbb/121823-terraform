<<<<<<< HEAD
# Required
variable "location" {}
variable "resource_group_name" {}
variable "net_name" {}
variable "net_add_space" {}
variable "dns_servers" {}
variable "tags" {}

# Optional
variable "peering_name" {
  default = ""
}
variable "remote_virtual_network_id" {
  default = ""
}
variable "peering_allow_forwarded_traffic" {
  default = false
}
variable "peering_allow_gateway_transit" {
  default = false
}
variable "peering_use_remote_gateways" {
  default = false
}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}
=======
# Required
variable "location" {}
variable "resource_group_name" {}
variable "net_name" {}
variable "net_add_space" {}
variable "dns_servers" {
  default = []
}
variable "tags" {}

# Optional
variable "peering_name" {
  default = ""
}
variable "remote_virtual_network_id" {
  default = ""
}
variable "peering_allow_forwarded_traffic" {
  default = false
}
variable "peering_allow_gateway_transit" {
  default = false
}
variable "peering_use_remote_gateways" {
  default = false
}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}
>>>>>>> 340c22c (hb-test-interview)
