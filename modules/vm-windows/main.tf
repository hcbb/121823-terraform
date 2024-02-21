<<<<<<< HEAD
locals {
  network_interface_name = coalesce(var.nicname, "${var.vm_name}-nic")
  ip_configuration_name = coalesce(var.ipname, var.vm_name)
  disk_name = coalesce(var.diskname, "${var.vm_name}-osdisk")
  join_domain_password = var.joindomain_password != null ? var.joindomain_password : var.joinadmin_password
}

resource "azurerm_network_interface" "main" {
  name                = local.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = local.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.iptype
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip
  }

  lifecycle {
    ignore_changes = [
      tags["cm-resource-parent"],
    ]
  }

  tags       = merge(var.tags, {
    type     = "vm"
  })
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  dynamic "storage_image_reference" {
    for_each = var.publisher != null ? ["storage_image_reference"] : []
    content {
      publisher = var.publisher
      offer     = var.offer
      sku       = var.sku
      version   = var.image_version
    }
  }
  storage_os_disk {
    name              = local.disk_name
    caching           = "ReadWrite"
    disk_size_gb      = var.disk_size_gb
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  boot_diagnostics {
    enabled        = true
    storage_uri    = var.storageuri
  }
  dynamic "os_profile" {
    for_each = var.use_os_profile == true ? [1] : []
    content {
      computer_name  = var.vm_name
      admin_username = var.admin_username
      admin_password = var.admin_password
    }
  }
  os_profile_windows_config {
    enable_automatic_upgrades   = var.os_profile_windows_config_enable_automatic_upgrades
    provision_vm_agent   = var.os_profile_windows_config_provision_vm_agent
    timezone             = var.os_profile_windows_config_timezone
  }
  dynamic "identity" {
    for_each = var.use_managed_identity ? ["identity"] : [] 
    content {
      type         = "UserAssigned"
      identity_ids = [var.managed_identity]
    }   
  }

  lifecycle {
    ignore_changes = [
      tags["cm-resource-parent"],
      additional_capabilities,
    ]
  }

  tags       = merge(var.tags, {
    startup_before_hours   = var.startup_before_hours,
    shutdown_after_hours  = var.shutdown_after_hours,
    startup_for_patching = var.startup_for_patching,
    datadog = var.datadog
    type     = "vm"
  })
}

resource "azurerm_virtual_machine_extension" "ConfigureRemotingForAnsible" {
  name                 = "ConfigureRemotingForAnsible"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  auto_upgrade_minor_version = var.ansible_auto_upgrade_minor_version
  automatic_upgrade_enabled  = false
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

    settings = <<SETTINGS
    {
        "fileUris": [ "https://raw.githubusercontent.com/ansible/ansible/v2.15.2/examples/scripts/ConfigureRemotingForAnsible.ps1" ],
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    }
SETTINGS

  lifecycle {
    ignore_changes = [
      settings,
    ]
  }

  tags       = merge(var.tags, {
    type     = "vm"
  })

  depends_on = [azurerm_virtual_machine.main]
}

resource "azurerm_virtual_machine_extension" "domjoin" {
  count = var.skipdomainjoin ? 0 : 1
  name                 = "JoinDomain"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  auto_upgrade_minor_version = var.domjoin_auto_upgrade_minor_version
  automatic_upgrade_enabled  = false
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain

  settings = <<SETTINGS
  {
     "Name": "${var.joindomain_domain}",
     "OUPath": "${var.joindomain_oupath}",
     "User": "${var.joindomain_username}",
     "Restart": "true",
     "Options": "3"
  }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "Password": "${local.join_domain_password}"
  }
PROTECTED_SETTINGS

  depends_on = [azurerm_virtual_machine.main]

  tags       = merge(var.tags, {
    type     = "vm"
  })
  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }
}

resource "azurerm_virtual_machine_extension" "avd-join" {
  count = var.virtual_desktop_host_pool_name != null ? 1 : 0

  name                       = "Microsoft.PowerShell.DSC"
  virtual_machine_id         = azurerm_virtual_machine.main.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${var.virtual_desktop_host_pool_name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${var.virtual_desktop_host_pool_registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.domjoin,
    var.virtual_desktop_host_pool_name
  ]

  lifecycle {
    ignore_changes = [
      type_handler_version,
      protected_settings,
      settings,
    ]
  }

}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count = var.diagnostic_monitoring ? 1 : 0
  name               = "eventhub-logging"
  target_resource_id = azurerm_network_interface.main.id
  eventhub_name = "eh-dev-hcbbdatadog"
  eventhub_authorization_rule_id = "/subscriptions/929e0340-bf36-45a2-8347-47f86b4715de/resourceGroups/rg-datadog/providers/Microsoft.EventHub/namespaces/ehn-dev-hcbbdatadog/authorizationRules/logs-splitting"

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  count = var.use_nsg == true ? 1 : 0
  
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_backup_protected_vm" "vm1" {
  count = var.enable_backup == true ? 1 : 0
  resource_group_name = var.backup_vault_resource_group_name
  recovery_vault_name = var.backup_vault_name 
  source_vm_id        = azurerm_virtual_machine.main.id
  backup_policy_id    = var.backup_policy_id
}
=======
locals {
  network_interface_name = coalesce(var.nicname, "${var.vm_name}-nic")
  ip_configuration_name = coalesce(var.ipname, var.vm_name)
  disk_name = coalesce(var.diskname, "${var.vm_name}-osdisk")
  join_domain_password = var.joindomain_password != null ? var.joindomain_password : var.joinadmin_password
}

resource "azurerm_network_interface" "main" {
  name                = local.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = local.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.iptype
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip
  }

  lifecycle {
    ignore_changes = [
      tags["cm-resource-parent"],
    ]
  }

  tags       = merge(var.tags, {
    type     = "vm"
  })
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  dynamic "storage_image_reference" {
    for_each = var.publisher != null ? ["storage_image_reference"] : []
    content {
      publisher = var.publisher
      offer     = var.offer
      sku       = var.sku
      version   = var.image_version
    }
  }
  storage_os_disk {
    name              = local.disk_name
    caching           = "ReadWrite"
    disk_size_gb      = var.disk_size_gb
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  boot_diagnostics {
    enabled        = true
    storage_uri    = var.storageuri
  }
  dynamic "os_profile" {
    for_each = var.use_os_profile == true ? [1] : []
    content {
      computer_name  = var.vm_name
      admin_username = var.admin_username
      admin_password = var.admin_password
    }
  }
  os_profile_windows_config {
    enable_automatic_upgrades   = var.os_profile_windows_config_enable_automatic_upgrades
    provision_vm_agent   = var.os_profile_windows_config_provision_vm_agent
    timezone             = var.os_profile_windows_config_timezone
  }
  dynamic "identity" {
    for_each = var.use_managed_identity ? ["identity"] : [] 
    content {
      type         = "UserAssigned"
      identity_ids = [var.managed_identity]
    }   
  }

  lifecycle {
    ignore_changes = [
      tags["cm-resource-parent"],
      additional_capabilities,
    ]
  }

  tags       = merge(var.tags, {
    startup_before_hours   = var.startup_before_hours,
    shutdown_after_hours  = var.shutdown_after_hours,
    startup_for_patching = var.startup_for_patching,
    datadog = var.datadog
    type     = "vm"
  })
}

resource "azurerm_virtual_machine_extension" "ConfigureRemotingForAnsible" {
  name                 = "ConfigureRemotingForAnsible"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  auto_upgrade_minor_version = var.ansible_auto_upgrade_minor_version
  automatic_upgrade_enabled  = false
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

    settings = <<SETTINGS
    {
        "fileUris": [ "https://raw.githubusercontent.com/ansible/ansible/v2.15.2/examples/scripts/ConfigureRemotingForAnsible.ps1" ],
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    }
SETTINGS

  lifecycle {
    ignore_changes = [
      settings,
    ]
  }

  tags       = merge(var.tags, {
    type     = "vm"
  })

  depends_on = [azurerm_virtual_machine.main]
}

resource "azurerm_virtual_machine_extension" "domjoin" {
  count = var.skipdomainjoin ? 0 : 1
  name                 = "JoinDomain"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  auto_upgrade_minor_version = var.domjoin_auto_upgrade_minor_version
  automatic_upgrade_enabled  = false
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain

  settings = <<SETTINGS
  {
     "Name": "${var.joindomain_domain}",
     "OUPath": "${var.joindomain_oupath}",
     "User": "${var.joindomain_username}",
     "Restart": "true",
     "Options": "3"
  }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "Password": "${local.join_domain_password}"
  }
PROTECTED_SETTINGS

  depends_on = [azurerm_virtual_machine.main]

  tags       = merge(var.tags, {
    type     = "vm"
  })
  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }
}

resource "azurerm_virtual_machine_extension" "avd-join" {
  count = var.virtual_desktop_host_pool_name != null ? 1 : 0

  name                       = "Microsoft.PowerShell.DSC"
  virtual_machine_id         = azurerm_virtual_machine.main.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${var.virtual_desktop_host_pool_name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${var.virtual_desktop_host_pool_registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.domjoin,
    var.virtual_desktop_host_pool_name
  ]

  lifecycle {
    ignore_changes = [
      type_handler_version,
      protected_settings,
      settings,
    ]
  }

}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count = var.diagnostic_monitoring ? 1 : 0
  name               = "eventhub-logging"
  target_resource_id = azurerm_network_interface.main.id
  eventhub_name = "eh-dev-hcbbdatadog"
  eventhub_authorization_rule_id = "/subscriptions/929e0340-bf36-45a2-8347-47f86b4715de/resourceGroups/rg-datadog/providers/Microsoft.EventHub/namespaces/ehn-dev-hcbbdatadog/authorizationRules/logs-splitting"

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  count = var.use_nsg == true ? 1 : 0
  
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_backup_protected_vm" "vm1" {
  count = var.enable_backup == true ? 1 : 0
  resource_group_name = var.backup_vault_resource_group_name
  recovery_vault_name = var.backup_vault_name 
  source_vm_id        = azurerm_virtual_machine.main.id
  backup_policy_id    = var.backup_policy_id
}
>>>>>>> 340c22c (hb-test-interview)
