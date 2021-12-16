output "web_snt_prefix" {
    value = azurerm_subnet.web_snt.address_prefixes
    description = "Web subnet prefix."
}
output "sql_snt_prefix" {
  value = azurerm_subnet.sql_snt.address_prefixes
  description = "SQL subnet prefix."
}
output "dev_snt_prefix" {
  value = azurerm_subnet.dev_snt.address_prefixes
  description = "Dev subnet prefix."
}
output "bas_snt_prefix" {
  value = azurerm_subnet.bas_snt.address_prefixes 
  description = "Bastion subnet prefix."
}
