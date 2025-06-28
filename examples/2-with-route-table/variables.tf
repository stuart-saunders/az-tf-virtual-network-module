variable "subscription_id" {
  type        = string
  description = "The Id of the subscription in which the resource should be created"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "vnets" {
  type = list(object({
    name          = optional(string, null)
    address_space = list(string)
    location      = optional(string, null)

    subnets = list(object({
      provider         = optional(string, "azurerm")
      name             = optional(string, null)
      address_prefixes = list(string)

      route_table = optional(object({
        name        = optional(string, null)
        name_suffix = optional(string, null)

        routes = optional(list(object({
          name                   = string
          address_prefix         = optional(string, null)
          next_hop_type          = optional(string, null)
          next_hop_in_ip_address = optional(string, null)
        })), [])
      }), null)

      existing_route_table = optional(object({
        name                = string
        resource_group_name = string
      }), null)

      existing_route_table_id = optional(string, null)
    }))
  }))
  description = <<-DESC
    The details required to create the Virtual Network.
    NOTE:
    **name**: The name to give the Virtual Network - should conform to the CAF naming standard
    **address_space"": The address space in CIDR format
    **location**: The location in which the Virtual Network should be created - should come from MPS Common
    **subnets**: The details of the Subnets to create within the Virtual Network
      **name**: The name of the Subnet
      **address_prefixes**: The Subnet's address space in CIDR format
      **nsg**: (Optional) The details of the NSG to create and associate with this Subnet
      **existing_nsg**: (Optional) The details of an existing NSG to associate with this Subnet - aids usability, by allowing the NSG name and RG to be provided, rather than its full Id
      **existing_nsg_id**: (Optional) The Id of an existing NSG to associate with this Subnet
  DESC
}
