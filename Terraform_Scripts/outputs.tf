output "sql_admin_username" {
  value = "quotes-sql-admin"
}

output "sql_admin_password" {
  value     = random_password.sql.result
  sensitive = true
}

output "connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=quotes-sql-admin;Password=${random_password.sql.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  sensitive = true
}
