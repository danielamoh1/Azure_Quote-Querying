# Resource Group for App
resource "azurerm_resource_group" "app" {
  name     = "quotes-rg-tf"
  location = "West US 3"

  tags = {
    project     = "quotes-app"
    owner       = "danielamoh"
    environment = "dev"
  }
}
