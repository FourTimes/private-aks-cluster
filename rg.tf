resource "azurerm_resource_group" "groupname" {
  location = var.location
  name     = "${var.project}-resourcegroup"
  tags     =  var.additional_tags
}