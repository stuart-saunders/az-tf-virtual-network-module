locals {

  vnets = { for vnet in var.vnets :
    vnet.name => vnet
  }

  peerings = merge([for vnet in var.vnets :
    {
      for peering in vnet.peerings :
      "${vnet.name}_${peering.name}" => peering
    }
  ]...)

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
