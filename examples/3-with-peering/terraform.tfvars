
# subscription_id = <sub_id>
resource_group_name = "rg-vnet-mod-example3"

vnets = [
  # Hub Vnet
  {
    name          = "vnet-mod-example3-hub"
    address_space = ["10.0.0.0/24"]

    peerings = [
      {
        name = "hub-to-spoke1"

        remote_virtual_network = {
          name = "vnet-mod-example3-spoke1"
        }

        source_to_remote_config = {
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
        }

        remote_to_source_config = {
          allow_virtual_network_access = true
        }
      },
      {
        name = "hub-to-spoke2"

        remote_virtual_network = {
          name = "vnet-mod-example3-spoke2"
        }

        source_to_remote_config = {
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
        }

        remote_to_source_config = {
          allow_virtual_network_access = true
        }
      }
    ]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.0.0/25"]
      },
    ]
  },

  # Spoke 1
  {
    name          = "vnet-mod-example3-spoke1"
    address_space = ["10.0.1.0/24"]

    subnets = [
      {
        provider         = "azapi"
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/25"]
      }
    ]
  },

  # Spoke 2
  {
    name          = "vnet-mod-example3-spoke2"
    address_space = ["10.0.2.0/24"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.2.0/25"]
      }
    ]
  }
]
