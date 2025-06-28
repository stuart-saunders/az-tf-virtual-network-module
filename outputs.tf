output "id" {
  description = "The Id of the Virtual Network created"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnets" {
  description = "The details of the subnets created"
  value       = azapi_resource.subnet
}

output "peerings" {
  description = "The details of vnet peerings"
  value       = azapi_resource.virtual_network_peering
}
