locals {
  rnum = tostring(var.resource_number)
  subnet_id_list = [
    azurerm_subnet.web_snt.id,
    azurerm_subnet.sql_snt.id,
    azurerm_subnet.dev_snt.id
  ]
}