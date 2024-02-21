<<<<<<< HEAD
#######################################################################################
# Module for creating/managing front door resources
# Terraform CDN Front Door documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile
# Microsoft Front Door and CDN documentation: https://learn.microsoft.com/en-us/azure/frontdoor/
# Azure CLI documentation for Front Door: https://learn.microsoft.com/en-us/cli/azure/afd?view=azure-cli-latest

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds

  tags = merge(var.tags, {
    type = "front door", datadog = "true"
  })
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  for_each = var.azurerm_cdn_frontdoor_endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  tags = merge(var.tags, {
    type = "front door"
  })
}

resource "azurerm_cdn_frontdoor_custom_domain" "main" {
  for_each = var.azurerm_cdn_frontdoor_custom_domains

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  dns_zone_id = each.value.dns_zone_id
  host_name   = each.value.host_name

  tls {
    certificate_type    = each.value.tls_certificate_type
    minimum_tls_version = each.value.tls_minimum_tls_version
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  for_each = var.azurerm_cdn_frontdoor_origin_groups

  name                                                      = each.value.name
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled                                  = each.value.session_affinity_enabled
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  load_balancing {
    additional_latency_in_milliseconds = each.value.lb_additional_latency_in_milliseconds
    sample_size                        = each.value.lb_sample_size
    successful_samples_required        = each.value.lb_successful_samples_required
  }
  health_probe {
    interval_in_seconds = each.value.hp_interval_in_seconds
    path                = each.value.hp_path
    protocol            = each.value.hp_protocol
    request_type        = each.value.hp_request_type
  }
}

resource "azurerm_cdn_frontdoor_origin" "main" {
  for_each = var.azurerm_cdn_frontdoor_origins

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main[each.value.cdn_frontdoor_origin_group_id].id
  origin_host_header             = each.value.origin_host_header
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  enabled                        = each.value.enabled
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  priority                       = each.value.priority
  weight                         = each.value.weight
}

resource "azurerm_cdn_frontdoor_route" "main" {
  for_each = var.azurerm_cdn_frontdoor_routes

  name                   = each.value.name
  enabled                = each.value.enabled
  forwarding_protocol    = each.value.forwarding_protocol
  https_redirect_enabled = each.value.https_redirect_enabled
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
  link_to_default_domain = each.value.link_to_default_domain
  cdn_frontdoor_origin_path = each.value.cdn_frontdoor_origin_path
  cdn_frontdoor_rule_set_ids = flatten([
    for rule_set_id in each.value.cdn_frontdoor_rule_set_ids : "${[azurerm_cdn_frontdoor_rule_set.main[rule_set_id].id]}"
  ])
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main[each.value.cdn_frontdoor_endpoint_id].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main[each.value.cdn_frontdoor_origin_group_id].id

  cdn_frontdoor_origin_ids = flatten([
    for origin_id in each.value.cdn_frontdoor_origin_ids : "${[azurerm_cdn_frontdoor_origin.main[origin_id].id]}"
  ])

  cdn_frontdoor_custom_domain_ids = flatten([
    for domain_id in each.value.cdn_frontdoor_custom_domain_ids : [azurerm_cdn_frontdoor_custom_domain.main[domain_id].id]
  ])

  dynamic "cache" {
    for_each = each.value.compression_enabled == true ? [1] : []
    content {
      query_string_caching_behavior = each.value.query_string_caching_behavior
      query_strings                 = each.value.query_strings
      compression_enabled           = each.value.compression_enabled
      content_types_to_compress     = each.value.content_types_to_compress
    }
  }
}

resource "azurerm_cdn_frontdoor_rule_set" "main" {
  for_each                 = var.azurerm_cdn_frontdoor_rule_sets
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_rule" "main" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.main, azurerm_cdn_frontdoor_origin.main]
  for_each   = var.azurerm_cdn_frontdoor_rule

  name                      = each.value.name
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.main[each.value.cdn_frontdoor_rule_set_id].id
  order                     = each.value.order
  actions {
    dynamic "url_rewrite_action" {
      for_each = each.value.actions.url_rewrite_actions
      iterator = action
      content {
        source_pattern          = action.value.source_pattern
        destination             = action.value.destination
        preserve_unmatched_path = action.value.preserve_unmatched_path
      }
    }
    dynamic "url_redirect_action" {
      for_each = each.value.actions.url_redirect_actions
      iterator = action
      content {
        redirect_type        = action.value.redirect_type
        destination_hostname = action.value.destination_hostname
        redirect_protocol    = action.value.redirect_protocol
        destination_path     = action.value.destination_path
        query_string         = action.value.query_string
        destination_fragment = action.value.destination_fragment
      }
    }
    dynamic "route_configuration_override_action" {
      for_each = each.value.actions.route_configuration_override_actions
      iterator = action
      content {
        cache_duration                = action.value.cache_duration
        cdn_frontdoor_origin_group_id = action.value.cdn_frontdoor_origin_group_id
        forwarding_protocol           = action.value.forwarding_protocol
        query_string_caching_behavior = action.value.query_string_caching_behavior
        query_string_parameters       = action.value.query_string_parameters
        compression_enabled           = action.value.compression_enabled
        cache_behavior                = action.value.cache_behavior
      }
    }
    dynamic "request_header_action" {
      for_each = each.value.actions.request_header_actions
      iterator = action
      content {
        header_action = action.value.header_action
        header_name   = action.value.header_name
        value         = action.value.value
      }
    }
    dynamic "response_header_action" {
      for_each = each.value.actions.response_header_actions
      iterator = action
      content {
        header_action = action.value.header_action
        header_name   = action.value.header_name
        value         = action.value.value
      }
    }
  }

  dynamic "conditions" {
    for_each = each.value.conditions[*]
    content {
      dynamic "remote_address_condition" {
        for_each = each.value.conditions.remote_address_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "request_method_condition" {
        for_each = each.value.conditions.request_method_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "query_string_condition" {
        for_each = each.value.conditions.query_string_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "post_args_condition" {
        for_each = each.value.conditions.post_args_conditions
        iterator = condition
        content {
          post_args_name   = condition.value.post_args_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_uri_condition" {
        for_each = each.value.conditions.request_uri_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_header_condition" {
        for_each = each.value.conditions.request_header_conditions
        iterator = condition
        content {
          header_name      = condition.value.header_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_body_condition" {
        for_each = each.value.conditions.request_body_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_scheme_condition" {
        for_each = each.value.conditions.request_scheme_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "url_path_condition" {
        for_each = each.value.conditions.url_path_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "url_file_extension_condition" {
        for_each = each.value.conditions.url_file_extension_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "url_filename_condition" {
        for_each = each.value.conditions.url_filename_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
          transforms       = condition.value.transforms
        }
      }
      dynamic "http_version_condition" {
        for_each = each.value.conditions.http_version_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "cookies_condition" {
        for_each = each.value.conditions.cookies_conditions
        iterator = condition
        content {
          cookie_name      = condition.value.cookie_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "is_device_condition" {
        for_each = each.value.conditions.is_device_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "socket_address_condition" {
        for_each = each.value.conditions.socket_address_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "client_port_condition" {
        for_each = each.value.conditions.client_port_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "server_port_condition" {
        for_each = each.value.conditions.server_port_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "host_name_condition" {
        for_each = each.value.conditions.host_name_conditions
        iterator = condition
        content {
          operator     = condition.value.operator
          match_values = condition.value.match_values
          transforms   = condition.value.transforms
        }
      }
      dynamic "ssl_protocol_condition" {
        for_each = each.value.conditions.ssl_protocol_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "main" {
  for_each                 = var.azurerm_cdn_frontdoor_security_policy
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  name                     = each.value.name

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = each.value.azurerm_cdn_frontdoor_firewall_policy
      association {
        patterns_to_match = each.value.patterns_to_match
        dynamic "domain" {
          for_each = each.value.cdn_frontdoor_domain_ids
          content {
            cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.main[domain.value].id
          }
        }
      }
    }
  }
}
=======
#######################################################################################
# Module for creating/managing front door resources
# Terraform CDN Front Door documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile
# Microsoft Front Door and CDN documentation: https://learn.microsoft.com/en-us/azure/frontdoor/
# Azure CLI documentation for Front Door: https://learn.microsoft.com/en-us/cli/azure/afd?view=azure-cli-latest

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds

  tags = merge(var.tags, {
    type = "front door", datadog = "true"
  })
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  for_each = var.azurerm_cdn_frontdoor_endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  tags = merge(var.tags, {
    type = "front door"
  })
}

resource "azurerm_cdn_frontdoor_custom_domain" "main" {
  for_each = var.azurerm_cdn_frontdoor_custom_domains

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  dns_zone_id = each.value.dns_zone_id
  host_name   = each.value.host_name

  tls {
    certificate_type    = each.value.tls_certificate_type
    minimum_tls_version = each.value.tls_minimum_tls_version
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  for_each = var.azurerm_cdn_frontdoor_origin_groups

  name                                                      = each.value.name
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled                                  = each.value.session_affinity_enabled
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  load_balancing {
    additional_latency_in_milliseconds = each.value.lb_additional_latency_in_milliseconds
    sample_size                        = each.value.lb_sample_size
    successful_samples_required        = each.value.lb_successful_samples_required
  }
  health_probe {
    interval_in_seconds = each.value.hp_interval_in_seconds
    path                = each.value.hp_path
    protocol            = each.value.hp_protocol
    request_type        = each.value.hp_request_type
  }
}

resource "azurerm_cdn_frontdoor_origin" "main" {
  for_each = var.azurerm_cdn_frontdoor_origins

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main[each.value.cdn_frontdoor_origin_group_id].id
  origin_host_header             = each.value.origin_host_header
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  enabled                        = each.value.enabled
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  priority                       = each.value.priority
  weight                         = each.value.weight
}

resource "azurerm_cdn_frontdoor_route" "main" {
  for_each = var.azurerm_cdn_frontdoor_routes

  name                   = each.value.name
  enabled                = each.value.enabled
  forwarding_protocol    = each.value.forwarding_protocol
  https_redirect_enabled = each.value.https_redirect_enabled
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
  link_to_default_domain = each.value.link_to_default_domain
  cdn_frontdoor_origin_path = each.value.cdn_frontdoor_origin_path
  cdn_frontdoor_rule_set_ids = flatten([
    for rule_set_id in each.value.cdn_frontdoor_rule_set_ids : "${[azurerm_cdn_frontdoor_rule_set.main[rule_set_id].id]}"
  ])
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main[each.value.cdn_frontdoor_endpoint_id].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main[each.value.cdn_frontdoor_origin_group_id].id

  cdn_frontdoor_origin_ids = flatten([
    for origin_id in each.value.cdn_frontdoor_origin_ids : "${[azurerm_cdn_frontdoor_origin.main[origin_id].id]}"
  ])

  cdn_frontdoor_custom_domain_ids = flatten([
    for domain_id in each.value.cdn_frontdoor_custom_domain_ids : [azurerm_cdn_frontdoor_custom_domain.main[domain_id].id]
  ])

  dynamic "cache" {
    for_each = each.value.compression_enabled == true ? [1] : []
    content {
      query_string_caching_behavior = each.value.query_string_caching_behavior
      query_strings                 = each.value.query_strings
      compression_enabled           = each.value.compression_enabled
      content_types_to_compress     = each.value.content_types_to_compress
    }
  }
}

resource "azurerm_cdn_frontdoor_rule_set" "main" {
  for_each                 = var.azurerm_cdn_frontdoor_rule_sets
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_rule" "main" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.main, azurerm_cdn_frontdoor_origin.main]
  for_each   = var.azurerm_cdn_frontdoor_rule

  name                      = each.value.name
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.main[each.value.cdn_frontdoor_rule_set_id].id
  order                     = each.value.order
  actions {
    dynamic "url_rewrite_action" {
      for_each = each.value.actions.url_rewrite_actions
      iterator = action
      content {
        source_pattern          = action.value.source_pattern
        destination             = action.value.destination
        preserve_unmatched_path = action.value.preserve_unmatched_path
      }
    }
    dynamic "url_redirect_action" {
      for_each = each.value.actions.url_redirect_actions
      iterator = action
      content {
        redirect_type        = action.value.redirect_type
        destination_hostname = action.value.destination_hostname
        redirect_protocol    = action.value.redirect_protocol
        destination_path     = action.value.destination_path
        query_string         = action.value.query_string
        destination_fragment = action.value.destination_fragment
      }
    }
    dynamic "route_configuration_override_action" {
      for_each = each.value.actions.route_configuration_override_actions
      iterator = action
      content {
        cache_duration                = action.value.cache_duration
        cdn_frontdoor_origin_group_id = action.value.cdn_frontdoor_origin_group_id
        forwarding_protocol           = action.value.forwarding_protocol
        query_string_caching_behavior = action.value.query_string_caching_behavior
        query_string_parameters       = action.value.query_string_parameters
        compression_enabled           = action.value.compression_enabled
        cache_behavior                = action.value.cache_behavior
      }
    }
    dynamic "request_header_action" {
      for_each = each.value.actions.request_header_actions
      iterator = action
      content {
        header_action = action.value.header_action
        header_name   = action.value.header_name
        value         = action.value.value
      }
    }
    dynamic "response_header_action" {
      for_each = each.value.actions.response_header_actions
      iterator = action
      content {
        header_action = action.value.header_action
        header_name   = action.value.header_name
        value         = action.value.value
      }
    }
  }

  dynamic "conditions" {
    for_each = each.value.conditions[*]
    content {
      dynamic "remote_address_condition" {
        for_each = each.value.conditions.remote_address_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "request_method_condition" {
        for_each = each.value.conditions.request_method_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "query_string_condition" {
        for_each = each.value.conditions.query_string_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "post_args_condition" {
        for_each = each.value.conditions.post_args_conditions
        iterator = condition
        content {
          post_args_name   = condition.value.post_args_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_uri_condition" {
        for_each = each.value.conditions.request_uri_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_header_condition" {
        for_each = each.value.conditions.request_header_conditions
        iterator = condition
        content {
          header_name      = condition.value.header_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_body_condition" {
        for_each = each.value.conditions.request_body_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
          transforms       = condition.value.transforms
        }
      }
      dynamic "request_scheme_condition" {
        for_each = each.value.conditions.request_scheme_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "url_path_condition" {
        for_each = each.value.conditions.url_path_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "url_file_extension_condition" {
        for_each = each.value.conditions.url_file_extension_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "url_filename_condition" {
        for_each = each.value.conditions.url_filename_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
          transforms       = condition.value.transforms
        }
      }
      dynamic "http_version_condition" {
        for_each = each.value.conditions.http_version_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "cookies_condition" {
        for_each = each.value.conditions.cookies_conditions
        iterator = condition
        content {
          cookie_name      = condition.value.cookie_name
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
          transforms       = condition.value.transforms
        }
      }
      dynamic "is_device_condition" {
        for_each = each.value.conditions.is_device_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "socket_address_condition" {
        for_each = each.value.conditions.socket_address_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "client_port_condition" {
        for_each = each.value.conditions.client_port_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
          match_values     = condition.value.match_values
        }
      }
      dynamic "server_port_condition" {
        for_each = each.value.conditions.server_port_conditions
        iterator = condition
        content {
          operator         = condition.value.operator
          match_values     = condition.value.match_values
          negate_condition = condition.value.negate_condition
        }
      }
      dynamic "host_name_condition" {
        for_each = each.value.conditions.host_name_conditions
        iterator = condition
        content {
          operator     = condition.value.operator
          match_values = condition.value.match_values
          transforms   = condition.value.transforms
        }
      }
      dynamic "ssl_protocol_condition" {
        for_each = each.value.conditions.ssl_protocol_conditions
        iterator = condition
        content {
          match_values     = condition.value.match_values
          operator         = condition.value.operator
          negate_condition = condition.value.negate_condition
        }
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "main" {
  for_each                 = var.azurerm_cdn_frontdoor_security_policy
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  name                     = each.value.name

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = each.value.azurerm_cdn_frontdoor_firewall_policy
      association {
        patterns_to_match = each.value.patterns_to_match
        dynamic "domain" {
          for_each = each.value.cdn_frontdoor_domain_ids
          content {
            cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.main[domain.value].id
          }
        }
      }
    }
  }
}
>>>>>>> 340c22c (hb-test-interview)
