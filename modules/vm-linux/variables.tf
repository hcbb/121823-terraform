<<<<<<< HEAD
#Required
variable "vm_name" {
  validation {
    condition = (length(var.vm_name) < 16)
    error_message = "Limit host name length to less then 15 character"
  }
}
variable "env" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "publisher" {}
variable "offer" {}
variable "sku" {}
variable "image_version" {}
variable "vm_size" {}
variable "admin_username" {}
variable "tags" {}

#Optional
variable "enable_backup" {
  default = "false"
}
variable "backup_vault_resource_group_name" {
  default = null
}
variable "backup_vault_name" {
  default = null
}
variable "backup_policy_id" {
  default = null
}
variable "managed_disk_type" {
  default = "StandardSSD_LRS"
}
variable "admin_password" {
  default = null
}
variable "enable_ip_forwarding" {
  default = false
}
variable "disk_size_gb" {
  default = 30
}
variable "public_ip" {
  default = null
}
variable "skipaadjoin" {
  default = true
}
variable "shutdown_after_hours" {
  default = null
}
variable "startup_before_hours" {
  default = null
}
variable "startup_for_patching" {
  default = null
}
variable "diagnostic_monitoring" {
  default = true
}
variable "use_managed_identity" {
  default = ""
}
variable "managed_identity" {
  default = null
}
variable "use_nsg" {
  default = "false"
}
variable "network_security_group_id" {
 default = null
}
variable "use_os_profile" {
  default = false
}
=======
#Required
variable "vm_name" {
  validation {
    condition = (length(var.vm_name) < 16)
    error_message = "Limit host name length to less then 15 character"
  }
}
variable "env" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "publisher" {}
variable "offer" {}
variable "sku" {}
variable "image_version" {}
variable "vm_size" {}
variable "admin_username" {}
variable "tags" {}

#Optional
variable "enable_backup" {
  default = "false"
}
variable "backup_vault_resource_group_name" {
  default = null
}
variable "backup_vault_name" {
  default = null
}
variable "backup_policy_id" {
  default = null
}
variable "managed_disk_type" {
  default = "StandardSSD_LRS"
}
variable "admin_password" {
  default = null
}
variable "enable_ip_forwarding" {
  default = false
}
variable "disk_size_gb" {
  default = 30
}
variable "public_ip" {
  default = null
}
variable "public_ip_address" {
  type = string
}
variable "skipaadjoin" {
  default = true
}
variable "shutdown_after_hours" {
  default = null
}
variable "startup_before_hours" {
  default = null
}
variable "startup_for_patching" {
  default = null
}
variable "diagnostic_monitoring" {
  default = true
}
variable "use_managed_identity" {
  default = ""
}
variable "managed_identity" {
  default = null
}
variable "use_nsg" {
  default = "false"
}
variable "network_security_group_id" {
 default = null
}
variable "use_os_profile" {
  default = false
}
>>>>>>> 340c22c (hb-test-interview)
