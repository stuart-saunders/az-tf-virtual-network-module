resource "azurerm_network_security_group" "existing" {
  for_each = toset(["01", "02"])

  name                = "nsg-existing-${each.value}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
