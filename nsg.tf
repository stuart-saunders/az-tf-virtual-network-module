resource "azurerm_network_security_group" "this" {
  for_each = (
    {
      for subnet in local.subnets : "${subnet.name}_${subnet.nsg.name}" => subnet.nsg
      if subnet.nsg != null
    }
  )

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = local.nsg_rules

  network_security_group_name = azurerm_network_security_group.this["${each.value.subnet_name}_${each.value.nsg_name}"].name
  resource_group_name         = var.resource_group_name

  name                         = each.value.name
  access                       = each.value.access
  direction                    = each.value.direction
  priority                     = each.value.priority
  protocol                     = each.value.protocol
  source_address_prefix        = each.value.source_address_prefix != null ? each.value.source_address_prefix : null
  source_address_prefixes      = each.value.source_address_prefixes != null ? each.value.source_address_prefixes : null
  source_port_range            = each.value.source_port_range != null ? each.value.source_port_range : null
  source_port_ranges           = each.value.source_port_ranges != null ? each.value.source_port_ranges : null
  destination_address_prefix   = each.value.destination_address_prefix != null ? each.value.destination_address_prefix : null
  destination_address_prefixes = each.value.destination_address_prefixes != null ? each.value.destination_address_prefixes : null
  destination_port_range       = each.value.destination_port_range != null ? each.value.destination_port_range : null
  destination_port_ranges      = each.value.destination_port_ranges != null ? each.value.destination_port_ranges : null
}

# provisioning explicit NSG associations si only required if using AzureRM provider - not required with AzApi provider
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    # create for each NSG specified for a subnet, and if the provider is AzureRM
    for key, subnet in local.subnets : "${subnet.name}_${subnet.nsg.name}" => subnet
    if try(subnet.nsg, null) != null && subnet.provider == "azurerm"
  }

  network_security_group_id = azurerm_network_security_group.this[each.key].id
  subnet_id                 = azurerm_subnet.this[each.value.name].id
}

resource "azurerm_subnet_network_security_group_association" "existing_nsg" {
  # create for each supplied Id of an existing NSG, and if the provider is AzureRM
  for_each = {
    for key, subnet in local.subnets : "${subnet.name}_${subnet.nsg_id}" => subnet
    if try(subnet.nsg_id, null) != null && subnet.provider == "azurerm"
  }

  network_security_group_id = each.value.nsg_id
  subnet_id                 = azurerm_subnet.this[each.value.name].id
}
