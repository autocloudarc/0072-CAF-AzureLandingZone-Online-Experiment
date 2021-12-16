locals {
  rnum = tostring(var.resource_number)
  bas3rdOctet = tostring(var.resource_number + 1)
  subnet_id_list = [
    azurerm_subnet.web_snt.id,
    azurerm_subnet.sql_snt.id,
    azurerm_subnet.dev_snt.id
  ]
}