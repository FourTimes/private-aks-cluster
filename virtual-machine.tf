resource "azurerm_public_ip" "pip" {
  name                = "${var.project}-vm-ip"
  location            = azurerm_resource_group.groupname.location
  resource_group_name = azurerm_resource_group.groupname.name
  allocation_method   = "Dynamic"
  tags                = var.additional_tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project}-vm-security-group"
  location            = azurerm_resource_group.groupname.location
  resource_group_name = azurerm_resource_group.groupname.name
  tags                = var.additional_tags
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.project}-vm-nic"
  location            = azurerm_resource_group.groupname.location
  resource_group_name = azurerm_resource_group.groupname.name
  tags                = var.additional_tags

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.subnet-jump.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.groupname.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "str" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.groupname.name
  location                 = azurerm_resource_group.groupname.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.additional_tags
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.project}-vm"
  location              = azurerm_resource_group.groupname.location
  resource_group_name   = azurerm_resource_group.groupname.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"
  tags                  = var.additional_tags

  os_disk {
    name                 = "osd"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "access-server"
  admin_username                  = var.vm_username
  disable_password_authentication = true
  custom_data = base64encode(data.template_file.init.rendered)

  admin_ssh_key {
    username   = var.vm_username
    public_key = var.ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.str.primary_blob_endpoint
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
