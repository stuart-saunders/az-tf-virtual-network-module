resource "azurerm_route_table" "existing" {
  for_each = toset(["01", "02"])

  name                = "rt-example2-existing-${each.value}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
