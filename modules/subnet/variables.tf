#Required
variable "location" {}
variable "resource_group_name" {}
variable "subnet_name" {}
variable "net_name" {}
variable "route_table_id" {}
#variable "service_endpoints" {}
variable "tags" {}

# Optional
variable "nat_gateway_id" {
  default = ""
}
variable "add_prefixes" {
  type = list(string)
}
variable "private_endpoint_network_policies_enabled" {
  default = true
}
variable "private_link_service_network_policies_enabled" {
  default = true
}
variable "network_security_group_association" {
  default = ""
}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}
variable "delegation" {
  type = list(object({
    name                       = string
    service_delegation_name    = string
    service_delegation_actions = list(string)
  }))
  default = []
}
