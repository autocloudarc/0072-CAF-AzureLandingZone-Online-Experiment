data "azurerm_key_vault_secret" "vm_pw" {
    name = var.kvt.name
    key_vault_id = var.kvt.id
    depends_on = [
      azurerm_key_vault.kvt
    ]
}
data "azurerm_storage_account" "sta" {
  name                     = "1${var.resource_codes.storage}${local.rnd_string}"
  resource_group_name      = azurerm_resource_group.rgp.name
  depends_on = [
    azurerm_storage_account.sta
  ]
}