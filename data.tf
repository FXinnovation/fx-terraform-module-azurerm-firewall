data "azurerm_firewall" "this" {
  count = var.firewall_exist == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}
