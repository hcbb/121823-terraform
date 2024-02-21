<<<<<<< HEAD
#Required
variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "account_kind" {}
variable "account_replication_type" {}
variable "tags" {}

#Optional
variable "min_tls_version" {
  default = "TLS1_2"
}
variable "allow_nested_items_to_be_public" {
  default = "true"
}
variable "table_encryption_key_type" {
  default = "Service"
}
variable "queue_encryption_key_type" {
  default = "Service"
}
variable "account_tier" {
  default = "Standard"
}
variable "public_network_access_enabled" {
  default = true
}
variable "default_to_oauth_authentication" {
  default = false
}
variable "allowed_copy_scope" {
  default = null
}
variable "cross_tenant_replication_enabled" {
  default = false
}
variable "containers" {
  type = map(object({
    name                  = string
    container_access_type = string
  }))
  default = {}
}
variable "shares" {
  type = map(object({
    name     = string
    quota    = string
    metadata = map(string)
  }))
  default = {}
}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
    scope                = optional(string)
  }))
  default = {}
}
variable "is_hns_enabled" {
  type    = bool
  default = false
}
variable "index_document" {
  description = "path from your repo root to index.html"
  default     = "index.html"
}
variable "error_404_path" {
  description = "path from your repo root to your custom 404 page"
  default     = null
}
variable "enable_static_website" {
  description = "Controls if static website to be enabled on the storage account. Possible values are `true` or `false`"
  default     = false
}
variable "private_endpoints" {
  type = map(object({
    subnet_id                     = string
    is_manual_connection          = optional(bool)
    subresource_names             = optional(list(string))
    request_message               = optional(string)
    private_dns_zone_ids          = optional(string)
    custom_network_interface_name = optional(string)
  }))
  default = {}
}
variable "private_dns_zone_group" {
  type = map(object({
    private_dns_zone_ids = string
  }))
  default = {}
}
variable "network_rules" {
  type = list(object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
    private_link_access = list(object({
      endpoint_tenant_id   = string
      endpoint_resource_id = string
    }))
  }))
  default = [
    {
      default_action             = "Deny"
      bypass                     = []
      ip_rules                   = []
      virtual_network_subnet_ids = []
      private_link_access        = []
    }
  ]
}
variable "azure_storagemgmtpolicy_rule" {
  type = map(object({
    name                                              = string
    enabled                                           = bool
    blob_types                                        = list(string)
    prefix_match                                      = list(string)
    sm_base_blob                                         = list(object({
       delete_after_days_since_modification_greater_than = number
    }))
    sm_version                                        = list(object({
       delete_after_days_since_creation               = number
    }))
  }))
  default = {
  }
=======
#Required
variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "account_kind" {}
variable "account_replication_type" {}
variable "tags" {}

#Optional
variable "min_tls_version" {
  default = "TLS1_2"
}
variable "allow_nested_items_to_be_public" {
  default = "true"
}
variable "table_encryption_key_type" {
  default = "Service"
}
variable "queue_encryption_key_type" {
  default = "Service"
}
variable "account_tier" {
  default = "Standard"
}
variable "public_network_access_enabled" {
  default = true
}
variable "default_to_oauth_authentication" {
  default = false
}
variable "allowed_copy_scope" {
  default = null
}
variable "cross_tenant_replication_enabled" {
  default = false
}
variable "containers" {
  type = map(object({
    name                  = string
    container_access_type = string
  }))
  default = {}
}
variable "shares" {
  type = map(object({
    name     = string
    quota    = string
    metadata = map(string)
  }))
  default = {}
}
variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
    scope                = optional(string)
  }))
  default = {}
}
variable "is_hns_enabled" {
  type    = bool
  default = false
}
variable "index_document" {
  description = "path from your repo root to index.html"
  default     = "index.html"
}
variable "error_404_path" {
  description = "path from your repo root to your custom 404 page"
  default     = null
}
variable "enable_static_website" {
  description = "Controls if static website to be enabled on the storage account. Possible values are `true` or `false`"
  default     = true
}
variable "private_endpoints" {
  type = map(object({
    subnet_id                     = string
    is_manual_connection          = optional(bool)
    subresource_names             = optional(list(string))
    request_message               = optional(string)
    private_dns_zone_ids          = optional(string)
    custom_network_interface_name = optional(string)
  }))
  default = {}
}
variable "private_dns_zone_group" {
  type = map(object({
    private_dns_zone_ids = string
  }))
  default = {}
}
variable "network_rules" {
  type = list(object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
    private_link_access = list(object({
      endpoint_tenant_id   = string
      endpoint_resource_id = string
    }))
  }))
  default = [
    {
      default_action             = "Deny"
      bypass                     = []
      ip_rules                   = []
      virtual_network_subnet_ids = []
      private_link_access        = []
    }
  ]
}
variable "azure_storagemgmtpolicy_rule" {
  type = map(object({
    name                                              = string
    enabled                                           = bool
    blob_types                                        = list(string)
    prefix_match                                      = list(string)
    sm_base_blob                                         = list(object({
       delete_after_days_since_modification_greater_than = number
    }))
    sm_version                                        = list(object({
       delete_after_days_since_creation               = number
    }))
  }))
  default = {
  }
>>>>>>> 340c22c (hb-test-interview)
}