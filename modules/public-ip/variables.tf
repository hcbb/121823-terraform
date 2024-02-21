<<<<<<< HEAD
variable "location" {}
variable "resource_group_name" {}
variable "pip_name" {}
variable "sku" {
  type    = string
  default = "Standard"
}
variable "allocation_method" {
  type    = string
  default = "Static"
}
variable "domain_name_label" {
  type    = string
  default = null
}
variable "zones" {
  type    = list(any)
  default = ["1", "2", "3"]
}

variable "tags" {}
=======
variable "location" {}
variable "resource_group_name" {}
variable "pip_name" {}
variable "sku" {
  type    = string
  default = "Standard"
}
variable "allocation_method" {
  type    = string
  default = "Static"
}
variable "domain_name_label" {
  type    = string
  default = null
}
variable "zones" {
  type    = list(any)
  default = ["1", "2", "3"]
}

variable "tags" {}
>>>>>>> 340c22c (hb-test-interview)
