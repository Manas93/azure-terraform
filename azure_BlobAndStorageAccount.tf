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

resource "azurerm_resource_group" "test" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_storage_account" "test" {
  name                     = "shwetatestoracc"
  resource_group_name      = "${azurerm_resource_group.test.name}"
  location                 = "${azurerm_resource_group.test.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test" {
  name                  = "content"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  storage_account_name  = "${azurerm_storage_account.test.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "test" {
  name                   = "my-awesome-content.zip"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  storage_account_name   = "${azurerm_storage_account.test.name}"
  storage_container_name = "${azurerm_storage_container.test.name}"
  type                   = "page"
  size                   = "1024"
}
