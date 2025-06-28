# AzureRM
resource "azurerm_subnet" "this" {
  for_each = {
    for key, value in local.subnets : key => value
    if value.provider == "azurerm"
  }

  name                 = each.key
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [1] : []

    content {
      name = each.value.delegation.name

      service_delegation {
        name    = each.value.delegation.service_delegation.name
        actions = each.value.delegation.service_delegation.actions
      }
    }
  }

  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies_enabled, null)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)

  service_endpoints           = try(each.value.service_endpoints, null)
  service_endpoint_policy_ids = try(each.value.service_endpoint_policy_ids, null)
}


# AzApi
resource "azapi_resource" "subnet" {
  for_each = {
    for key, value in local.subnets : key => value
    if value.provider == "azapi"
  }

  type      = local.defaults.azapi_type.subnet
  name      = each.key
  parent_id = azurerm_virtual_network.this.id
  locks     = [azurerm_virtual_network.this.id]


  body = {
    properties = {
      addressPrefixes = each.value.address_prefixes
      networkSecurityGroup = {
        id = try(each.value.nsg, null) != null ? azurerm_network_security_group.this["${each.value.name}_${each.value.nsg.name}"].id : each.value.nsg_id
      }
      serviceEndpoints = [for endpoint in(each.value.service_endpoints != null ? each.value.service_endpoints : []) : {
        service = endpoint
      }]
    }
  }
  depends_on = [azurerm_network_security_group.this]
}
