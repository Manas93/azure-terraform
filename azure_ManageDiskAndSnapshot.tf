provider "azurerm" {
# whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  subscription_id = "${var.subsId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
}

variable "subsId" {
}

variable "clientId" {
}

variable "clientSecret" {
}

variable "tenantId" {
}

variable "region" {
}

variable "prefix" {
  default = "tfazure"
}

variable "disk_size_in_gb" {
}

resource "azurerm_resource_group" "test" {
  name     = "${var.prefix}-rg"
  location = "${var.region}"
}

resource "azurerm_managed_disk" "test" {
  name                 = "${var.prefix}-managed-disk"
  location             = "${azurerm_resource_group.test.location}"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.disk_size_in_gb}"
}

resource "azurerm_snapshot" "test" {
  name                = "${var.prefix}-ani-snapshot"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  create_option       = "Copy"
  source_uri          = "${azurerm_managed_disk.test.id}"
}
