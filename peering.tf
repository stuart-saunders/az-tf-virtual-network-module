# AzureRM
resource "azurerm_virtual_network_peering" "this" {
  for_each = {
    for key, value in local.peerings : key => value
    if value.provider == "azurerm"
  }

  name                         = each.key
  resource_group_name          = var.resource_group_name
  virtual_network_name         = each.value.source_virtual_network_name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  allow_virtual_network_access = each.value.allow_virtual_network_access
  use_remote_gateways          = each.value.use_remote_gateways
}

# AzApi
resource "azapi_resource" "virtual_network_peering" {
  for_each = {
    for key, value in local.peerings : key => value
    if value.provider == "azapi"
  }

  type      = local.defaults.azapi_type.virtual_network_peering
  parent_id = "/subscriptions/${each.value.subscription_id}/resourceGroups/${each.value.source_virtual_network_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value.source_virtual_network_name}"

  name = try(each.value.name, null) != null ? each.value.name : each.value.remote_virtual_network.name

  body = {
    properties = {
      remoteVirtualNetwork = {
        id = each.value.remote_virtual_network_id
      }
      allowForwardedTraffic     = each.value.allow_forwarded_traffic
      allowGatewayTransit       = each.value.allow_gateway_transit
      allowVirtualNetworkAccess = each.value.allow_virtual_network_access
      useRemoteGateways         = each.value.use_remote_gateways
    }
  }
}
