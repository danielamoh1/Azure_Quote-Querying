# App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "quotes-asp-tf"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "quotes-webapp-tf"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "DB_USER"                  = "quotes-sql-admin"
    "DB_PASSWORD"              = random_password.sql.result
    "DB_SERVER"                = azurerm_mssql_server.sql.fully_qualified_domain_name
    "DB_NAME"                  = azurerm_mssql_database.db.name
  }
}
