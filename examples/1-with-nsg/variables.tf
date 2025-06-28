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

      nsg = optional(object({
        name = string

        rules = optional(list(object({
          name                         = string
          priority                     = string
          direction                    = string
          access                       = string
          protocol                     = string
          destination_address_prefix   = optional(string, null)
          destination_address_prefixes = optional(list(string), null)
          destination_port_range       = string
          source_address_prefix        = optional(string, null)
          source_address_prefixes      = optional(list(string), null)
          source_port_range            = string
        })), [])
      }), null)

      existing_nsg = optional(object({
        name                = string
        resource_group_name = string
      }), null)

      existing_nsg_id = optional(string, null)
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
