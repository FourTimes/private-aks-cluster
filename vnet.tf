resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-network"
  resource_group_name = azurerm_resource_group.groupname.name
  location            = azurerm_resource_group.groupname.location
  address_space       = ["10.0.0.0/16"]
  tags     =  var.additional_tags
}


resource "azurerm_subnet" "subnet-jump" {
  name                 = "${var.project}-jump-subnet"
  resource_group_name  = azurerm_resource_group.groupname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-aks-subnet"
  resource_group_name  = azurerm_resource_group.groupname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.16.0/20"]
  enforce_private_link_endpoint_network_policies = true
}
