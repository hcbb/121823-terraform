<<<<<<< HEAD
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = var.enable_ip_forwarding

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
  tags = merge(var.tags, {
    type = "vm"
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

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    disk_size_gb      = var.disk_size_gb
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUZ3B123O2M5nW5Nok0qq8Vqv5pdEuHlSSdXhXYRhi3hIS00iVf78peKtZrcgJBYOa+1Rihhlu7HfXMR8qTftHWyVGh+RwTnAS7qAlJoo09WVJlZ0QeWbQH8sMmK4szGYy6TGm6LeWovaN8j2eQkRKCKuXkNf05wsOn7Nq8PVddqrqoNvvQFEC7km+A2dPIUBh7vGBYtDYxOfyELnCeFUgDBxWOVIUgy4RPe1gWaqQEi9QtvYLVppTo++xlTq814OB/emOzmMV3h1iy5f8tgX9vTeN9XCwBhZ7s+m+xQvgTCSpfsWa65vdrPwKGkF+kpib7xBP7WvEbGPhqezV2yz5"
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  dynamic "identity" {
    for_each = var.use_managed_identity == "" ? [] : [1]
    content {
      type         = "UserAssigned"
      identity_ids = [var.managed_identity]
    }
  }

  tags = merge(var.tags, {
    shutdown_after_hours = var.shutdown_after_hours,
    startup_before_hours = var.startup_before_hours,
    startup_for_patching = var.startup_for_patching,
    type                 = "vm"
  })
}

resource "azurerm_virtual_machine_extension" "aadjoin" {
  count                      = var.skipaadjoin ? 0 : 1
  name                       = "AADLoginForLinux"
  virtual_machine_id         = azurerm_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                       = "AADLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_virtual_machine.main]

  tags = merge(var.tags, {
    type = "vm"
  })
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count                          = var.diagnostic_monitoring ? 1 : 0
  name                           = "eventhub-logging"
  target_resource_id             = azurerm_network_interface.main.id
  eventhub_name                  = "eh-dev-hcbbdatadog"
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
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = var.enable_ip_forwarding

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
  tags = merge(var.tags, {
    type = "vm"
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

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    disk_size_gb      = var.disk_size_gb
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPfqbh2c5kJ4JnlI30gwPRh22Q1sl39/mFitLtRjBypyGX0lpfza0984KKagJlCe/9t+/xxWs5JfRWQkuCtCQz+OP1zU9FTrGjGit/TJDx/QsCNi9neqJpSGtWhwj6k/Pn0R+BaZOB1n35yzmgZX387GV6P3SFb6izeicu/oOvLLF52nvKOc3PtvSifnW6t10HwMXCW+N+Ao1FrZw6PZgUZpL1CJkJZTqNk+2HutCjjf82Aay/9HWzgKDOhxT8yEGOv0yKJmq1y9abtL/lwOrw973tTWJ4TJxZPSqmw3DNVtF0pPYmHwa3HklRYUGIzcG6U6C7kz8ZEpvpy3tzJbqN"
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  dynamic "identity" {
    for_each = var.use_managed_identity == "" ? [] : [1]
    content {
      type         = "UserAssigned"
      identity_ids = [var.managed_identity]
    }
  }

  tags = merge(var.tags, {
    shutdown_after_hours = var.shutdown_after_hours,
    startup_before_hours = var.startup_before_hours,
    startup_for_patching = var.startup_for_patching,
    type                 = "vm"
  })
}

resource "azurerm_virtual_machine_extension" "aadjoin" {
  count                      = var.skipaadjoin ? 0 : 1
  name                       = "AADLoginForLinux"
  virtual_machine_id         = azurerm_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                       = "AADLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_virtual_machine.main]

  tags = merge(var.tags, {
    type = "vm"
  })
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count                          = var.diagnostic_monitoring ? 1 : 0
  name                           = "eventhub-logging"
  target_resource_id             = azurerm_network_interface.main.id
  eventhub_name                  = "eh-dev-hcbbdatadog"
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
