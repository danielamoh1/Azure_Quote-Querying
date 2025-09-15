resource "azurerm_virtual_network" "vnet" {
  name                = "quotes-vnet-tf"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["11.0.1.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp-subnet"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["11.0.2.0/24"]
}
