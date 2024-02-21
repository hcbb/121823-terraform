<<<<<<< HEAD
#######################################################################################
# Module for creating/managing Front Door WAF policy resources; this only supports
#  Front Door Standard and Premium - it does not support Classic Front Door WAF polices
# Terraform documentation for Front Door CDN WAF: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy
# Microsoft Front Door WAF documentation: https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview
# Azure CLI command reference for WAF for Front Door Standard/Premium: https://learn.microsoft.com/en-us/cli/azure/network/front-door/waf-policy?view=azure-cli-latest

# By default, this module will apply a custom rule that blocks all non-US traffic to our websites.
# In order to allow non-US traffic, set the value of the variable "block_non_us_traffic" to false
#  in the root that is calling this module

# Check for the "block_non_us_traffic" variable; if true, merge geoblocking rule with other rules in
#  the root; if false, simply use the rules specified in the root
locals {
  combined_custom_rules = var.block_non_us_traffic ? concat(var.geo_blocking_rule, var.custom_rules) : (var.custom_rules)
}

# Create the WAF policy resource
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  enabled                           = var.enabled
  mode                              = var.mode
  custom_block_response_status_code = var.custom_block_response_status_code
  custom_block_response_body        = var.custom_block_response_body
  sku_name                          = var.sku_name
  redirect_url                      = var.redirect_url

  dynamic "custom_rule" {
    for_each = var.ip_allow_list == null ? [] : [1]
    content {
      name     = "IPAllowList"
      enabled  = true
      priority = 5
      type     = "MatchRule"
      action   = "Allow"

      match_condition {
        operator           = "IPMatch"
        negation_condition = false
        match_values       = var.ip_allow_list
        transforms         = []

        match_variable = "RemoteAddr"
      }
    }
  }

  dynamic "custom_rule" {
    for_each = local.combined_custom_rules
    content {
      name     = custom_rule.value.name
      enabled  = custom_rule.value.enabled
      priority = custom_rule.value.priority
      #        rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold = custom_rule.value.rate_limit_threshold
      type                 = custom_rule.value.type
      action               = custom_rule.value.action
      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          operator           = match_condition.value.operator
          negation_condition = match_condition.value.negation_condition
          match_values       = match_condition.value.match_values
          transforms         = match_condition.value.transforms
          match_variable     = match_condition.value.match_variable
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = var.managed_rules
    content {
      action  = managed_rule.value.action
      type    = managed_rule.value.type
      version = managed_rule.value.version
      dynamic "override" {
        for_each = managed_rule.value.overrides
        content {
          rule_group_name = override.value.rule_group_name

          dynamic "rule" {
            for_each = override.value.rules
            content {
              action  = rule.value.action
              enabled = rule.value.enabled
              rule_id = rule.value.rule_id
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
=======
#######################################################################################
# Module for creating/managing Front Door WAF policy resources; this only supports
#  Front Door Standard and Premium - it does not support Classic Front Door WAF polices
# Terraform documentation for Front Door CDN WAF: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy
# Microsoft Front Door WAF documentation: https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview
# Azure CLI command reference for WAF for Front Door Standard/Premium: https://learn.microsoft.com/en-us/cli/azure/network/front-door/waf-policy?view=azure-cli-latest

# By default, this module will apply a custom rule that blocks all non-US traffic to our websites.
# In order to allow non-US traffic, set the value of the variable "block_non_us_traffic" to false
#  in the root that is calling this module

# Check for the "block_non_us_traffic" variable; if true, merge geoblocking rule with other rules in
#  the root; if false, simply use the rules specified in the root
locals {
  combined_custom_rules = var.block_non_us_traffic ? concat(var.geo_blocking_rule, var.custom_rules) : (var.custom_rules)
}

# Create the WAF policy resource
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  enabled                           = var.enabled
  mode                              = var.mode
  custom_block_response_status_code = var.custom_block_response_status_code
  custom_block_response_body        = var.custom_block_response_body
  sku_name                          = var.sku_name
  redirect_url                      = var.redirect_url

  dynamic "custom_rule" {
    for_each = var.ip_allow_list == null ? [] : [1]
    content {
      name     = "IPAllowList"
      enabled  = true
      priority = 5
      type     = "MatchRule"
      action   = "Allow"

      match_condition {
        operator           = "IPMatch"
        negation_condition = false
        match_values       = var.ip_allow_list
        transforms         = []

        match_variable = "RemoteAddr"
      }
    }
  }

  dynamic "custom_rule" {
    for_each = local.combined_custom_rules
    content {
      name     = custom_rule.value.name
      enabled  = custom_rule.value.enabled
      priority = custom_rule.value.priority
      #        rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold = custom_rule.value.rate_limit_threshold
      type                 = custom_rule.value.type
      action               = custom_rule.value.action
      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          operator           = match_condition.value.operator
          negation_condition = match_condition.value.negation_condition
          match_values       = match_condition.value.match_values
          transforms         = match_condition.value.transforms
          match_variable     = match_condition.value.match_variable
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = var.managed_rules
    content {
      action  = managed_rule.value.action
      type    = managed_rule.value.type
      version = managed_rule.value.version
      dynamic "override" {
        for_each = managed_rule.value.overrides
        content {
          rule_group_name = override.value.rule_group_name

          dynamic "rule" {
            for_each = override.value.rules
            content {
              action  = rule.value.action
              enabled = rule.value.enabled
              rule_id = rule.value.rule_id
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
>>>>>>> 340c22c (hb-test-interview)
