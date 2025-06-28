locals {

  vnets = { for vnet in var.vnets :
    vnet.name => {
      name          = vnet.name
      address_space = vnet.address_space
      location      = vnet.location

      # if an existing NSG has been specified for a subnet, construct and append its Id
      subnets = [for subnet in vnet.subnets :
        merge(
          subnet,
          { nsg_id = try("/subscriptions/${var.subscription_id}/resourceGroups/${subnet.existing_nsg.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${subnet.existing_nsg.name}", subnet.existing_nsg_id) }
        )
      ]
    }
  }

  subnets = merge([for vnet in var.vnets :
    {
      for subnet in vnet.subnets :
      "${vnet.name}_${subnet.name}" => merge(
        { vnet_name = vnet.name },
        subnet
      )
    }
  ]...)
}
