resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan.id != null ? [1] : []

    content {
      enable = var.ddos_protection_plan.enable
      id     = var.ddos_protection_plan.id
    }
  }

  tags = var.tags
}

resource "azurerm_virtual_network_dns_servers" "this" {
  for_each = length(var.dns_servers) > 0 ? toset(["this"]) : []

  virtual_network_id = azurerm_virtual_network.this.id
  dns_servers        = var.dns_servers
}
