data "azurerm_lb_backend_address_pool" "bep" {
  name = "BackEndAddressPool"
  loadbalancer_id = var.lb_id
}