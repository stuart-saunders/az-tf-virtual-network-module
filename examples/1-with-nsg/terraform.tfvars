# subscription_id = <sub_id>
resource_group_name = "rg-vnet-mod-example1"

vnets = [
  {
    name          = "vnet-mod-example1-01"
    address_space = ["10.0.0.0/24"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.0.0/25"]

        nsg = {
          name = "nsg-snet01"
        }
      },
      {
        name             = "snet-02"
        address_prefixes = ["10.0.0.128/25"]

        nsg = {
          name = "nsg-snet02"

          rules = [
            {
              name                    = "winrm"
              priority                = "500"
              direction               = "Inbound"
              access                  = "Allow"
              protocol                = "Tcp"
              source_port_range       = "*"
              destination_port_range  = "5985"
              source_address_prefixes = ["0.0.0.0/0"]
            },
            {
              name                       = "DenyAllOutbound"
              priority                   = "1000"
              direction                  = "Outbound"
              access                     = "Deny"
              protocol                   = "*"
              source_port_range          = "*"
              destination_port_range     = "*"
              destination_address_prefix = "0.0.0.0/0"
            },
          ]
        }
      }
    ]
  },
  {
    name          = "vnet-mod-example1-02"
    address_space = ["10.0.1.0/24"]

    subnets = [
      {
        name             = "snet-01"
        address_prefixes = ["10.0.1.0/25"]

        existing_nsg = {
          name                = "nsg-existing-01"
          resource_group_name = "rg-vnet-mod-example1"
        }
      },
      {
        name             = "snet-vnet02-02"
        address_prefixes = ["10.0.1.128/25"]
      }
    ]
  }
]
