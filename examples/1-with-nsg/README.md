# Az Virtual Network Module Example - with NSGs

The Az Virtual Network Module can be used to create Virtual Networks. This example demonstrates its use in creating a set of virtual networks, each containing subnets with NSGs.

The example shows the following:-
- provisioning an empty NSG and associating with a subnet
- provisioning an NSG with rules, and associating with a subnet
- associating a pre-existing NSG with a subnet

The `vnets` variable should be used to specify a list (of 1 or more) objects defining the virtual networks to create. Each vnet object can contain its own list of subnet objects, with the definition of each.

```
vnets = [
  name          = "vnet-example-01"
  address_space = ["10.0.0.0/16"]

  subnets = [
    {
      name             = "snet-01"
      address_prefixes = ["10.0.1.0/24"]

      nsg = {
        name = "nsg-01"

        rules = [
          {
            name = "rule1"
            ...
          },
          {
            name = "rule2"
            ...
          }
        ]
      }
    },
    {
      name             = "snet-02"
      address_prefixes = ["10.0.2.0/24"]

      existing_nsg = {
        name                = "nsg-existing-01"
        resource_group_name = "rg-existing"
      }
    }
  ]
]
```