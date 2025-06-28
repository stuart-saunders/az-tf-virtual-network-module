
# subscription_id = <sub_id>
resource_group_name = "rg-vnet-mod-example2"

vnets = [
  {
    name          = "vnet-mod-example2-01"
    address_space = ["10.0.0.0/24"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.0.0/25"]

        route_table = {
          name = "rt-01"
          routes = [
            {
              name                   = "default"
              address_prefix         = "0.0.0.0/0"
              next_hop_type          = "VirtualAppliance"
              next_hop_in_ip_address = "192.168.219.4"
            }
          ]
        }
      },
      {
        name             = "snet-02"
        address_prefixes = ["10.0.0.128/25"]

        route_table = {
          name = "rt-02"
        }
      }
    ]
  },
  {
    name          = "vnet-mod-example2-02"
    address_space = ["10.0.1.0/24"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/25"]

        existing_route_table = {
          name                = "rt-example2-existing-01"
          resource_group_name = "rg-vnet-mod-example2"
        }
      }
    ]
  }
]
