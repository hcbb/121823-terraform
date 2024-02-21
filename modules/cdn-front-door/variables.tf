<<<<<<< HEAD
#Required variables
variable "location" {}
variable "resource_group_name" {}
variable "name" {}

variable "azurerm_cdn_frontdoor_custom_domains" {
  type = map(object({
    name                    = string
    dns_zone_id             = string
    host_name               = string
    tls_certificate_type    = string
    tls_minimum_tls_version = string
  }))
}

variable "azurerm_cdn_frontdoor_routes" {
  type = map(object({
    name                            = string
    cdn_frontdoor_endpoint_id       = string
    cdn_frontdoor_origin_group_id   = string
    cdn_frontdoor_origin_ids        = list(string)
    cdn_frontdoor_rule_set_ids      = list(string)
    cdn_frontdoor_origin_path       = optional(string)
    enabled                         = bool
    forwarding_protocol             = string
    https_redirect_enabled          = bool
    patterns_to_match               = list(string)
    supported_protocols             = list(string)
    cdn_frontdoor_custom_domain_ids = list(string)
    link_to_default_domain          = bool

    query_string_caching_behavior = string
    query_strings                 = list(string)
    compression_enabled           = bool
    content_types_to_compress     = list(string)
  }))
}

variable "azurerm_cdn_frontdoor_rule_sets" {
  type = map(object({
    name = string
  }))
}

variable "azurerm_cdn_frontdoor_rule" {
  type = map(object({
    name                      = string
    cdn_frontdoor_rule_set_id = optional(string)
    order                     = optional(number)
    actions = object({
      url_rewrite_actions = optional(list(object({
        source_pattern          = optional(string)
        destination             = optional(string)
        preserve_unmatched_path = optional(bool, false)
      })), [])
      url_redirect_actions = optional(list(object({
        redirect_type        = string
        destination_hostname = string
        redirect_protocol    = optional(string, "MatchRequest")
        destination_path     = optional(string, "")
        query_string         = optional(string, "")
        destination_fragment = optional(string, "")
      })), [])
      route_configuration_override_actions = optional(list(object({
        cache_duration                = optional(string, "1.12:00:00")
        cdn_frontdoor_origin_group_id = optional(string)
        forwarding_protocol           = optional(string, "MatchRequest")
        query_string_caching_behavior = optional(string, "IgnoreQueryString")
        query_string_parameters       = optional(list(string))
        compression_enabled           = optional(bool, false)
        cache_behavior                = optional(string, "HonorOrigin")
      })), [])
      request_header_actions = optional(list(object({
        header_action = string
        header_name   = string
        value         = optional(string)
      })), [])
      response_header_actions = optional(list(object({
        header_action = string
        header_name   = string
        value         = optional(string)
      })), [])
    })
    conditions = optional(object({
      remote_address_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      request_method_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
      query_string_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      post_args_conditions = optional(list(object({
        post_args_name   = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_uri_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_header_conditions = optional(list(object({
        header_name      = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_body_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_scheme_conditions = optional(list(object({
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
        match_values     = optional(list(string), ["HTTP"])
      })), [])
      url_path_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      url_file_extension_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = list(string)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      url_filename_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      http_version_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
      cookies_conditions = optional(list(object({
        cookie_name      = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      is_device_conditions = optional(list(object({
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
        match_values     = optional(list(string), ["Mobile"])
      })), [])
      socket_address_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      client_port_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      server_port_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
      })), [])
      host_name_conditions = optional(list(object({
        operator     = string
        match_values = optional(list(string))
        transforms   = optional(list(string), ["Lowercase"])
      })), [])
      ssl_protocol_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
    }), null)
  }))
}

variable "azurerm_cdn_frontdoor_security_policy" {
  type = map(object({
    name                                  = string
    patterns_to_match                     = optional(list(string))
    azurerm_cdn_frontdoor_firewall_policy = string
    cdn_frontdoor_domain_ids              = list(string)
  }))
}

#Optional variable

variable "sku_name" {
  default = "Standard_AzureFrontDoor"
}
variable "response_timeout_seconds" {
  default = 60
}
variable "azurerm_cdn_frontdoor_endpoints" {
  type = map(object({
    name = string
  }))
  default = {}
}

variable "azurerm_cdn_frontdoor_origin_groups" {
  type = map(object({
    name                                                      = string
    session_affinity_enabled                                  = string
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = number
    lb_additional_latency_in_milliseconds                     = number
    lb_sample_size                                            = number
    lb_successful_samples_required                            = number
    hp_interval_in_seconds                                    = number
    hp_path                                                   = string
    hp_protocol                                               = string
    hp_request_type                                           = string
  }))
  default = {}
}
variable "azurerm_cdn_frontdoor_origins" {
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group_id  = string
    certificate_name_check_enabled = bool
    enabled                        = bool
    host_name                      = string
    http_port                      = number
    https_port                     = number
    origin_host_header             = string
    priority                       = number
    weight                         = number
  }))
  default = {}
}

variable "tags" {}
=======
#Required variables
variable "location" {}
variable "resource_group_name" {}
variable "name" {}

variable "azurerm_cdn_frontdoor_custom_domains" {
  type = map(object({
    name                    = string
    dns_zone_id             = string
    host_name               = string
    tls_certificate_type    = string
    tls_minimum_tls_version = string
  }))
}

variable "azurerm_cdn_frontdoor_routes" {
  type = map(object({
    name                            = string
    cdn_frontdoor_endpoint_id       = string
    cdn_frontdoor_origin_group_id   = string
    cdn_frontdoor_origin_ids        = list(string)
    cdn_frontdoor_rule_set_ids      = list(string)
    cdn_frontdoor_origin_path       = optional(string)
    enabled                         = bool
    forwarding_protocol             = string
    https_redirect_enabled          = bool
    patterns_to_match               = list(string)
    supported_protocols             = list(string)
    cdn_frontdoor_custom_domain_ids = list(string)
    link_to_default_domain          = bool

    query_string_caching_behavior = string
    query_strings                 = list(string)
    compression_enabled           = bool
    content_types_to_compress     = list(string)
  }))
}

variable "azurerm_cdn_frontdoor_rule_sets" {
  type = map(object({
    name = string
  }))
}

variable "azurerm_cdn_frontdoor_rule" {
  type = map(object({
    name                      = string
    cdn_frontdoor_rule_set_id = optional(string)
    order                     = optional(number)
    actions = object({
      url_rewrite_actions = optional(list(object({
        source_pattern          = optional(string)
        destination             = optional(string)
        preserve_unmatched_path = optional(bool, false)
      })), [])
      url_redirect_actions = optional(list(object({
        redirect_type        = string
        destination_hostname = string
        redirect_protocol    = optional(string, "MatchRequest")
        destination_path     = optional(string, "")
        query_string         = optional(string, "")
        destination_fragment = optional(string, "")
      })), [])
      route_configuration_override_actions = optional(list(object({
        cache_duration                = optional(string, "1.12:00:00")
        cdn_frontdoor_origin_group_id = optional(string)
        forwarding_protocol           = optional(string, "MatchRequest")
        query_string_caching_behavior = optional(string, "IgnoreQueryString")
        query_string_parameters       = optional(list(string))
        compression_enabled           = optional(bool, false)
        cache_behavior                = optional(string, "HonorOrigin")
      })), [])
      request_header_actions = optional(list(object({
        header_action = string
        header_name   = string
        value         = optional(string)
      })), [])
      response_header_actions = optional(list(object({
        header_action = string
        header_name   = string
        value         = optional(string)
      })), [])
    })
    conditions = optional(object({
      remote_address_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      request_method_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
      query_string_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      post_args_conditions = optional(list(object({
        post_args_name   = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_uri_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_header_conditions = optional(list(object({
        header_name      = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_body_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      request_scheme_conditions = optional(list(object({
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
        match_values     = optional(list(string), ["HTTP"])
      })), [])
      url_path_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      url_file_extension_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = list(string)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      url_filename_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      http_version_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
      cookies_conditions = optional(list(object({
        cookie_name      = string
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
        transforms       = optional(list(string), ["Lowercase"])
      })), [])
      is_device_conditions = optional(list(object({
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
        match_values     = optional(list(string), ["Mobile"])
      })), [])
      socket_address_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      client_port_conditions = optional(list(object({
        operator         = string
        negate_condition = optional(bool, false)
        match_values     = optional(list(string))
      })), [])
      server_port_conditions = optional(list(object({
        operator         = string
        match_values     = list(string)
        negate_condition = optional(bool, false)
      })), [])
      host_name_conditions = optional(list(object({
        operator     = string
        match_values = optional(list(string))
        transforms   = optional(list(string), ["Lowercase"])
      })), [])
      ssl_protocol_conditions = optional(list(object({
        match_values     = list(string)
        operator         = optional(string, "Equal")
        negate_condition = optional(bool, false)
      })), [])
    }), null)
  }))
}

variable "azurerm_cdn_frontdoor_security_policy" {
  type = map(object({
    name                                  = string
    patterns_to_match                     = optional(list(string))
    azurerm_cdn_frontdoor_firewall_policy = string
    cdn_frontdoor_domain_ids              = list(string)
  }))
}

#Optional variable

variable "sku_name" {
  default = "Standard_AzureFrontDoor"
}
variable "response_timeout_seconds" {
  default = 60
}
variable "azurerm_cdn_frontdoor_endpoints" {
  type = map(object({
    name = string
  }))
  default = {}
}

variable "azurerm_cdn_frontdoor_origin_groups" {
  type = map(object({
    name                                                      = string
    session_affinity_enabled                                  = string
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = number
    lb_additional_latency_in_milliseconds                     = number
    lb_sample_size                                            = number
    lb_successful_samples_required                            = number
    hp_interval_in_seconds                                    = number
    hp_path                                                   = string
    hp_protocol                                               = string
    hp_request_type                                           = string
  }))
  default = {}
}
variable "azurerm_cdn_frontdoor_origins" {
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group_id  = string
    certificate_name_check_enabled = bool
    enabled                        = bool
    host_name                      = string
    http_port                      = number
    https_port                     = number
    origin_host_header             = string
    priority                       = number
    weight                         = number
  }))
  default = {}
}

variable "tags" {}
>>>>>>> 340c22c (hb-test-interview)
