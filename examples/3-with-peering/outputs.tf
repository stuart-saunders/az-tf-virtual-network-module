output "virtual_network_id" {
  value = [for vnet in module.vnets :
    vnet.id
  ]
}

output "subnet_ids" {
  value = { for vnet in module.vnets :
    "${vnet.name}" => {
      subnets = { for subnet in vnet.subnets :
        "${subnet.name}" => {
          id = subnet.id
        }
      }
    }
  }
}
