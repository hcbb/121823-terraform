<<<<<<< HEAD
#Required
variable "vm_name" {
  validation {
    condition = (length(var.vm_name) < 15)
    error_message = "Limit host name length to less then 15 character"
  }
}
variable "vm_size" {}
variable "env" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
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
variable "enable_accelerated_networking" {
  type = string
  default = false
}
variable "publisher" {
  default = null
}
variable "offer" {
  default = null
}
variable "sku" {
  default = null
}
variable "image_version" {
  default = null
}
variable "managed_disk_type" {
  default = "StandardSSD_LRS"
}
variable "disk_size_gb" {
  default = 127
}
variable "admin_username" {
  default = null
}
variable "admin_password" {
  default = null
}
variable "joindomain_username" {
  default = "hcbb.lan\\\\join"
}
variable "joindomain_password" {
  default = null
}
variable "joindomain_oupath" {
  default = "OU=Member Servers,DC=hcbb,DC=lan"
}
variable "joindomain_domain" {
  default = "hcbb.lan"
}
variable "join_domain_password" {
  default = null
}
variable "joinadmin_password" {
  default = null
}
variable "public_ip" {
  default = null
}
variable "shutdown_after_hours" {
  default = false
}
variable "startup_before_hours" {
  default = false
}
variable "startup_for_patching" {
  default = null
}
variable "create_option" {
  default = "FromImage"
}
variable "diskname" {
  default = ""
}
variable "ipname" {
  default = ""
}
variable "nicname" {
  default = ""
}
variable "storageuri" {
  default = ""
}
variable "skipdomainjoin" {
  default = false
}
variable "use_nsg" {
  default = "false"
}
variable "network_security_group_id" {
 default = null
}
variable "diagnostic_monitoring" {
  default = false
}
variable "datadog" {
  default = false
}
variable "iptype" {
  default = "Dynamic"
}
variable "private_ip_address" {
  default = null
}
variable "use_os_profile" {
  default = false
}
variable "os_profile_windows_config_enable_automatic_upgrades" {
  default = true
}
variable "os_profile_windows_config_provision_vm_agent" {
  default = true
}
variable "os_profile_windows_config_timezone" {
  default = null
}
variable "use_managed_identity" {
  default = false
}
variable "managed_identity" {
  default = null
}
variable "zone" {
  default = null
}
variable "ansible_auto_upgrade_minor_version" {
  default = true
}
variable "domjoin_auto_upgrade_minor_version" {
  default = true
}
variable "virtual_desktop_host_pool_name" {
  default = null
}
variable "virtual_desktop_host_pool_registration_token" {
  default = null
}
=======
#Required
variable "vm_name" {
  validation {
    condition = (length(var.vm_name) < 15)
    error_message = "Limit host name length to less then 15 character"
  }
}
variable "vm_size" {}
variable "env" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
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
variable "enable_accelerated_networking" {
  type = string
  default = false
}
variable "publisher" {
  default = null
}
variable "offer" {
  default = null
}
variable "sku" {
  default = null
}
variable "image_version" {
  default = null
}
variable "managed_disk_type" {
  default = "StandardSSD_LRS"
}
variable "disk_size_gb" {
  default = 127
}
variable "admin_username" {
  default = null
}
variable "admin_password" {
  default = null
}
variable "joindomain_username" {
  default = "hcbb.lan\\\\join"
}
variable "joindomain_password" {
  default = null
}
variable "joindomain_oupath" {
  default = "OU=Member Servers,DC=hcbb,DC=lan"
}
variable "joindomain_domain" {
  default = "hcbb.lan"
}
variable "join_domain_password" {
  default = null
}
variable "joinadmin_password" {
  default = null
}
variable "public_ip" {
  default = null
}
variable "shutdown_after_hours" {
  default = false
}
variable "startup_before_hours" {
  default = false
}
variable "startup_for_patching" {
  default = null
}
variable "create_option" {
  default = "FromImage"
}
variable "diskname" {
  default = ""
}
variable "ipname" {
  default = ""
}
variable "nicname" {
  default = ""
}
variable "storageuri" {
  default = ""
}
variable "skipdomainjoin" {
  default = false
}
variable "use_nsg" {
  default = "false"
}
variable "network_security_group_id" {
 default = null
}
variable "diagnostic_monitoring" {
  default = false
}
variable "datadog" {
  default = false
}
variable "iptype" {
  default = "Dynamic"
}
variable "private_ip_address" {
  default = null
}
variable "use_os_profile" {
  default = false
}
variable "os_profile_windows_config_enable_automatic_upgrades" {
  default = true
}
variable "os_profile_windows_config_provision_vm_agent" {
  default = true
}
variable "os_profile_windows_config_timezone" {
  default = null
}
variable "use_managed_identity" {
  default = false
}
variable "managed_identity" {
  default = null
}
variable "zone" {
  default = null
}
variable "ansible_auto_upgrade_minor_version" {
  default = true
}
variable "domjoin_auto_upgrade_minor_version" {
  default = true
}
variable "virtual_desktop_host_pool_name" {
  default = null
}
variable "virtual_desktop_host_pool_registration_token" {
  default = null
}
>>>>>>> 340c22c (hb-test-interview)
