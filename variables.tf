variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
}

variable "project" {}
variable "location" {}
variable "ssh_key" {}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "vm_username" {}