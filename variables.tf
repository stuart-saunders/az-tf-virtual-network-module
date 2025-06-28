variable "subscription_id" {
  type        = string
  description = "The Id of the Subscription in which the Virtual Network should be created"
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name the Resource Group in which to create the Virtual Network"
}

variable "location" {
  type        = string
  description = "The location in which to create the Virtual Network. Defaults to UKSouth"
  default     = "uksouth"
}

variable "name" {
  type        = string
  description = "(Required) The name of the Virtual Network to create"
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space(s) used by the Virtual Network"
}

variable "subnets" {
  type = list(object({
    provider = optional(string, "azurerm")

    name             = string
    address_prefixes = list(string)

    delegation = optional(object({
      name = optional(string, null)
      service_delegation = optional(object({
        name    = optional(string, null)
        actions = optional(list(string), null)
      }), null)
    }), null)

    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)

    service_endpoints           = optional(list(string), null)
    service_endpoint_policy_ids = optional(list(string), null)

    nsg = optional(object({
      name = string
      rules = optional(list(object({
        name                         = string
        priority                     = string
        direction                    = string
        access                       = string
        protocol                     = string
        source_address_prefix        = optional(string, null)
        source_address_prefixes      = optional(list(string), null)
        source_port_range            = optional(string, null)
        source_port_ranges           = optional(list(string), null)
        destination_address_prefix   = optional(string, null)
        destination_address_prefixes = optional(list(string), null)
        destination_port_range       = optional(string, null)
        destination_port_ranges      = optional(list(string), null)
      })), [])
    }), null)

    nsg_id = optional(string, null)

    route_table = optional(object({
      name                          = string
      bgp_route_propagation_enabled = optional(bool, true)

      routes = optional(list(object({
        name                   = string
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string, null)
      })), [])
    }), null)

    route_table_id = optional(string, null)
  }))
  description = <<-DESC
    The details of any required Subnets
    **provider**: Indicates which provider should be used to provision the resource. Can be `azurerm` or `azapi`.

    **name**: The name of the Subnet - hould conform to the CAF naming standard
    **address_space**: The address space in CIDR format
    **location**: The location in which the Virtual Network should be created - name should come from MPS Common

    **private_endpoint_network_policies_enabled**: (Optional) Enable or Disable network policies for the private endpoint on the Subnet
    **private_link_service_network_policies_enabled**: (Optional) Enable or Disable network policies for the private link service on the Subnet
    **service_endpoints**: (Optional) A list of Service Endpoints to associate with the Subnet
    **service_endpoint_policy_ids**: (Optional) A list of Service Endpoint Ids to associate with the Subnet
    **nsg**: (Optional) Creates an NSG with the supplied details and associates with the Subnet
    **nsg_id**: (Optional) The Id of an existing NSG to associate with the Subnet
    **route_table**: (Optional) Creates a Route Table with the supplied details and associates with the Subnet
    **route_table_id**: (Optional) The Id of an existing Route Table to associate with the Subnet
  DESC
  default     = []
}

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) List of IP addresses of DNS servers"
  default     = []
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  description = "(Optional) Enables a DDoS Protection Plan on the Virtual Network"
  default = {
    enable = false
    id     = null
  }
}

variable "edge_zone" {
  type        = string
  description = "(Optional) The Edge Zone within the Azure Region where this Virtual Network should exist"
  default     = null
}

variable "flow_timeout_in_minutes" {
  type        = number
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  default     = null
}

variable "peerings" {
  type = list(object({
    provider = optional(string, "azurerm")

    name = optional(string, null)

    remote_virtual_network = object({
      id                  = optional(string, null)
      name                = optional(string, null)
      resource_group_name = optional(string, null)
      subscription_id     = optional(string, null)
    })

    source_to_remote_config = optional(object({
      allow_forwarded_traffic      = optional(bool, null)
      allow_gateway_transit        = optional(bool, null)
      allow_virtual_network_access = optional(bool, null)
      use_remote_gateways          = optional(bool, null)
      triggers                     = optional(map(string), null)
    }), {})

    remote_to_source_config = optional(object({
      allow_forwarded_traffic      = optional(bool, null)
      allow_gateway_transit        = optional(bool, null)
      allow_virtual_network_access = optional(bool, null)
      use_remote_gateways          = optional(bool, null)
      triggers                     = optional(map(string), null)
    }), {})
  }))
  description = <<-DESC
    (Optional) A list of remote Virtual Networks to which this Virtual Network should be peered.
    Peerings will be created in both directions, to and from the remote network.
    The peering configurations (source-to-remote and remote-to-source) can be defined separately.

    **provider**: Indicates which provider should be used to provision the resource. Can be `azurerm` or `azapi`. Allows for cross-subscription peerings to be created.
    **name**: The name of the peering to create.
    **remote_virtual_network**: The details of the remote network to peer to.
    **source_to_remote_config**: The configuration of the outbound peering.
    **remote_to_source_config**: The configuration of the inbound peering.
  DESC
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The list of tags to apply to the resources"
  default     = {}
}
