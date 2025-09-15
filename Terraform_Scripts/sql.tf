# Generate password
resource "random_password" "sql" {
  length  = 18
  special = true
}

# SQL Server
resource "azurerm_mssql_server" "sql" {
  name                         = "quotes-sqlserver-tf"
  resource_group_name          = azurerm_resource_group.app.name
  location                     = azurerm_resource_group.app.location
  version                      = "12.0"
  administrator_login          = "quotes-sql-admin"
  administrator_login_password = random_password.sql.result
}

# SQL Database
resource "azurerm_mssql_database" "db" {
  name      = "quotes-db-tf"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S0"
}

# Private Endpoint for SQL
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "quotes-sql-pe"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "quotes-sql-privateservice"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
