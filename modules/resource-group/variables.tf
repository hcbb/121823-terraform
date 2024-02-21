<<<<<<< HEAD
variable "location" {}
variable "resource_group_name" {}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}
variable "tags" {}
=======
variable "location" {}
variable "resource_group_name" {}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}
variable "tags" {}
>>>>>>> 340c22c (hb-test-interview)
