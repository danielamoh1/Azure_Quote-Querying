resource "azurerm_service_plan" "plan" {
  name                = "quotes-serviceplan-tf"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  os_type             = "Linux"
  sku_name            = "P1v3"
  zone_balancing_enabled = true
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "quotes-webapp-tf"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
    vnet_route_all_enabled = true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "ConnectionStrings__QuotesDb" = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sql.administrator_login};Password=${random_password.sql.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  }
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "quotes-sql-pe-tf"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "quotes-sql-privateservice-tf"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
