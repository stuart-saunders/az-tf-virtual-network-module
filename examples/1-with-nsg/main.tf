resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "vnets" {
  source   = "../../"
  for_each = local.vnets

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = each.value.name
  address_space = each.value.address_space

  subnets = each.value.subnets

  depends_on = [
    azurerm_network_security_group.existing
  ]
}
