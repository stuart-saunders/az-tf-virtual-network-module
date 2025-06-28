# Az Virtual Network Module Example - with Peerings

The Az Virtual Network Module can be used to create Virtual Networks. This example demonstrates its use in creating a set of virtual networks, each containing subnets with Route Tables.

The example shows the following:-
- provisioning 3 Vnets - a Hub and 2 Spokes
- creating 2-way peerings between the Hub and each Spoke

The `vnets` variable should be used to specify a list (of 1 or more) objects defining the virtual networks to create. Each vnet object can contain its own list of peering objects, with the definition of each.

Note that for each peering defined, both directions will be created, so in the Hub and Spoke setup in this example, only the Hub needs to define the peerings and both directions will be provisioned - the spokes do not need to define their peering to the Hub.

```
vnets = [
  {
    name          = "vnet-hub"
    address_space = ["10.0.0.0/16"]

    peerings = [
      {
        name = "hub-to-spoke1"

        remote_virtual_network = {
          name = "vnet-spoke1"
        }
      },
      {
        name = "hub-to-spoke2"

        remote_virtual_network = {
          name = "vnet-spoke2"
        }
      }
    ]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/24"]
      }
    ]
  },
  {
    name          = "vnet-spoke1"
    address_space = ["10.0.1.0/16"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/24"]
      }
    ]
  },
  {
    name          = "vnet-spoke2"
    address_space = ["10.0.2.0/16"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/24"]
      }
    ]
  }
]
```