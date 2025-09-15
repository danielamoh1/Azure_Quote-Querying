# Generate SQL password
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

# SQL Database (serverless + HA across AZs)
resource "azurerm_mssql_database" "db" {
  name                        = "quotes-db-tf"
  server_id                   = azurerm_mssql_server.sql.id
  sku_name                    = "GP_S_Gen5_1"
  max_size_gb                 = 32
  zone_redundant              = true
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
  read_scale                  = true
  storage_account_type        = "LRS"
}
