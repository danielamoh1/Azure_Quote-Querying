output "sql_admin_username" {
  value = azurerm_mssql_server.sql.administrator_login
}

output "sql_admin_password" {
  value     = random_password.sql.result
  sensitive = true
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.sql_pe.name
}
