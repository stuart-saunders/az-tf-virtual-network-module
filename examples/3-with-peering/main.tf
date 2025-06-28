resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "vnets" {
  source   = "../../"
  for_each = local.vnets

  subscription_id     = var.subscription_id
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = each.value.name
  address_space = each.value.address_space

  peerings = each.value.peerings
  subnets  = each.value.subnets
}
