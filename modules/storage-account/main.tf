<<<<<<< HEAD
locals {
  if_static_website_enabled = var.enable_static_website ? [{}] : []
}

resource "azurerm_storage_account" "main" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  min_tls_version                  = var.min_tls_version
  table_encryption_key_type        = var.table_encryption_key_type
  queue_encryption_key_type        = var.queue_encryption_key_type
  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  enable_https_traffic_only        = "true"
  is_hns_enabled                   = var.is_hns_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  default_to_oauth_authentication  = var.default_to_oauth_authentication
  #allowed_copy_scope               = var.allowed_copy_scope

  dynamic "static_website" {
    for_each = local.if_static_website_enabled
    content {
      index_document     = var.index_document
      error_404_document = var.error_404_path
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = network_rules.value.private_link_access
        content {
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.account_kind == "FileStorage" ? [] : [1]
    content {
      logging {
        delete                = true
        read                  = true
        write                 = true
        version               = "1.0"
        retention_policy_days = 90
      }
      hour_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 7
      }
      minute_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 7
      }
    }
  }

  lifecycle {
    ignore_changes = [
      azure_files_authentication
    ]
  }

  tags = merge(var.tags, {
    type = "storage"
  })
}

resource "azurerm_storage_container" "main" {
  for_each = var.containers

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = each.value.scope != null ? each.value.scope : azurerm_storage_account.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

resource "azurerm_storage_share" "main" {
  for_each = var.shares

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.main.name
  quota                = each.value.quota

  metadata = each.value.metadata
}

resource "azurerm_private_endpoint" "main" {
  for_each = var.private_endpoints

  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_ids != null ? [1] : []

    content {
      name                 = "default"
      private_dns_zone_ids = [each.value.private_dns_zone_ids]
    }
  }

  private_service_connection {
    name                           = var.name
    subresource_names              = each.value.subresource_names != null ? each.value.subresource_names : ["blob"]
    private_connection_resource_id = resource.azurerm_storage_account.main.id
    is_manual_connection           = each.value.is_manual_connection != null ? each.value.is_manual_connection : true
    request_message                = each.value.is_manual_connection != false ? "Request from HCBB" : null
  }

  tags = merge(var.tags, {
    type = "private endpoint"
  })
}

resource "azurerm_storage_management_policy" "main" {
  count               = var.azure_storagemgmtpolicy_rule == null ? 0 : 1
  storage_account_id = azurerm_storage_account.main.id

  dynamic "rule" {
    for_each = var.azure_storagemgmtpolicy_rule
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      filters {
        blob_types = rule.value.blob_types
        prefix_match = rule.value.prefix_match
      }
      actions {
        dynamic "base_blob" {
          for_each =  rule.value.sm_base_blob != null ? [1] : []
          content {
            delete_after_days_since_modification_greater_than = rule.value.sm_base_blob[base_blob.key].delete_after_days_since_modification_greater_than #base_blob.value.delete_after_days_since_modification_greater_than
            
          }
        }
        dynamic "version" {
          for_each = rule.value.sm_version != null ? [1] : [] 
          content {
            delete_after_days_since_creation = rule.value.sm_version[version.key].delete_after_days_since_creation#version.value.delete_after_days_since_creation

          }
        }
      }
    }
  }
}
=======
locals {
  if_static_website_enabled = var.enable_static_website ? [{}] : []
}

resource "azurerm_storage_account" "main" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  min_tls_version                  = var.min_tls_version
  table_encryption_key_type        = var.table_encryption_key_type
  queue_encryption_key_type        = var.queue_encryption_key_type
  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  enable_https_traffic_only        = "true"
  is_hns_enabled                   = var.is_hns_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  default_to_oauth_authentication  = var.default_to_oauth_authentication
  #allowed_copy_scope               = var.allowed_copy_scope

  dynamic "static_website" {
    for_each = local.if_static_website_enabled
    content {
      index_document     = var.index_document
      error_404_document = var.error_404_path
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = network_rules.value.private_link_access
        content {
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.account_kind == "FileStorage" ? [] : [1]
    content {
      logging {
        delete                = true
        read                  = true
        write                 = true
        version               = "1.0"
        retention_policy_days = 90
      }
      hour_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 7
      }
      minute_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 7
      }
    }
  }

  lifecycle {
    ignore_changes = [
      azure_files_authentication
    ]
  }

  tags = merge(var.tags, {
    type = "storage"
  })
}

resource "azurerm_storage_container" "main" {
  for_each = var.containers

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  scope                = each.value.scope != null ? each.value.scope : azurerm_storage_account.main.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

resource "azurerm_storage_share" "main" {
  for_each = var.shares

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.main.name
  quota                = each.value.quota

  metadata = each.value.metadata
}

resource "azurerm_private_endpoint" "main" {
  for_each = var.private_endpoints

  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_ids != null ? [1] : []

    content {
      name                 = "default"
      private_dns_zone_ids = [each.value.private_dns_zone_ids]
    }
  }

  private_service_connection {
    name                           = var.name
    subresource_names              = each.value.subresource_names != null ? each.value.subresource_names : ["blob"]
    private_connection_resource_id = resource.azurerm_storage_account.main.id
    is_manual_connection           = each.value.is_manual_connection != null ? each.value.is_manual_connection : true
    request_message                = each.value.is_manual_connection != false ? "Request from HCBB" : null
  }

  tags = merge(var.tags, {
    type = "private endpoint"
  })
}

resource "azurerm_storage_management_policy" "main" {
  count               = var.azure_storagemgmtpolicy_rule == null ? 0 : 1
  storage_account_id = azurerm_storage_account.main.id

  dynamic "rule" {
    for_each = var.azure_storagemgmtpolicy_rule
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      filters {
        blob_types = rule.value.blob_types
        prefix_match = rule.value.prefix_match
      }
      actions {
        dynamic "base_blob" {
          for_each =  rule.value.sm_base_blob != null ? [1] : []
          content {
            delete_after_days_since_modification_greater_than = rule.value.sm_base_blob[base_blob.key].delete_after_days_since_modification_greater_than #base_blob.value.delete_after_days_since_modification_greater_than
            
          }
        }
        dynamic "version" {
          for_each = rule.value.sm_version != null ? [1] : [] 
          content {
            delete_after_days_since_creation = rule.value.sm_version[version.key].delete_after_days_since_creation#version.value.delete_after_days_since_creation

          }
        }
      }
    }
  }
}
>>>>>>> 340c22c (hb-test-interview)
