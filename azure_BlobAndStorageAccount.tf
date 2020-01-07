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

variable "prefix" {
  default = "tfvmex"
}

variable "disk_size_mb" {
}

variable "region" {
}

resource "azurerm_resource_group" "test" {
  name     = "${var.prefix}-resources"
  location = "${var.region}"
}

resource "azurerm_storage_account" "test" {
  name                     = "${var.prefix}-storage"
  resource_group_name      = "${azurerm_resource_group.test.name}"
  location                 = "${azurerm_resource_group.test.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test" {
  name                  = "${var.prefix}-content"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  storage_account_name  = "${azurerm_storage_account.test.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "test" {
  name                   = "${var.prefix}-content.zip"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  storage_account_name   = "${azurerm_storage_account.test.name}"
  storage_container_name = "${azurerm_storage_container.test.name}"
  type                   = "page"
  size                   = "${var.disk_size_mb}"
}
