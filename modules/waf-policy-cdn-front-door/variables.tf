<<<<<<< HEAD
# Required
variable "name" {
  type = string
}
variable "resource_group_name" {}
variable "enabled" {
  default = true
}
variable "mode" {
  default = "Prevention"
}
variable "custom_block_response_status_code" {
  default = 403
}
variable "custom_block_response_body" {
  default = "Prevented by WAF policy"
}
variable "sku_name" {
  type    = string
  default = "Standard"
}
variable "custom_rules" {
  type = list(object({
    name                 = string
    enabled              = bool
    priority             = number
    type                 = string
    action               = string
    rate_limit_threshold = optional(number)

    match_conditions = list(object({
      operator           = string
      negation_condition = bool
      match_values       = list(string)
      transforms         = list(string)

      match_variable = string
    }))
  }))
}
variable "managed_rules" {
  type = list(object({
    action  = optional(string)
    type    = string
    version = string

    overrides = list(object({
      rule_group_name = string
      rules = list(object({
        action  = string
        enabled = bool
        rule_id = string
      }))
    }))
  }))
}


# Optional
variable "ip_allow_list" {
  type    = list(string)
  default = null
}
variable "block_non_us_traffic" {
  type    = bool
  default = true
}
variable "geo_blocking_rule" {
  default = [
    {
      name                 = "BlockNonUSTraffic"
      enabled              = true
      priority             = 10
      type                 = "MatchRule"
      action               = "Block"
      rate_limit_threshold = 10
      match_conditions = [
        {
          operator           = "GeoMatch"
          negation_condition = true
          match_values       = ["US"]
          transforms         = []
          match_variable     = "SocketAddr"
        }
      ]
    }
  ]
}
variable "redirect_url" {
  default = null
}
variable "tags" {}
=======
# Required
variable "name" {
  type = string
}
variable "resource_group_name" {}
variable "enabled" {
  default = true
}
variable "mode" {
  default = "Prevention"
}
variable "custom_block_response_status_code" {
  default = 403
}
variable "custom_block_response_body" {
  default = "Prevented by WAF policy"
}
variable "sku_name" {
  type    = string
  default = "Standard"
}
variable "custom_rules" {
  type = list(object({
    name                 = string
    enabled              = bool
    priority             = number
    type                 = string
    action               = string
    rate_limit_threshold = optional(number)

    match_conditions = list(object({
      operator           = string
      negation_condition = bool
      match_values       = list(string)
      transforms         = list(string)

      match_variable = string
    }))
  }))
}
variable "managed_rules" {
  type = list(object({
    action  = optional(string)
    type    = string
    version = string

    overrides = list(object({
      rule_group_name = string
      rules = list(object({
        action  = string
        enabled = bool
        rule_id = string
      }))
    }))
  }))
}


# Optional
variable "ip_allow_list" {
  type    = list(string)
  default = null
}
variable "block_non_us_traffic" {
  type    = bool
  default = true
}
variable "geo_blocking_rule" {
  default = [
    {
      name                 = "BlockNonUSTraffic"
      enabled              = true
      priority             = 10
      type                 = "MatchRule"
      action               = "Block"
      rate_limit_threshold = 10
      match_conditions = [
        {
          operator           = "GeoMatch"
          negation_condition = true
          match_values       = ["US"]
          transforms         = []
          match_variable     = "SocketAddr"
        }
      ]
    }
  ]
}
variable "redirect_url" {
  default = null
}
variable "tags" {}
>>>>>>> 340c22c (hb-test-interview)
