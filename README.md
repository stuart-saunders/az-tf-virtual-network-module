# Azure Virtual Network Module

Terraform Module for provisioning Virtual Networks on Azure.

## Description

The module supports the creation of a Virtual Network, in addition to its dependent, child resources, allowing a resource hierarchy to be defined in an object, and using this to provision the required resources. Each Virtual Network can contain multiple peerings and subnets, each of which can contain a Network Security Group, itself containing multiple Network Security Rules. Each Subnet can also contain a Route Table, which itself can contain multiple routes. All of these can be defined within a single object, which the module will use this to provision the resources required.

When defining lists of peerings, for any supplied remote networks, peerings will be created in both directions, with the settings for each peering being able to be individually configured.

Although each of the child resources in the hierarchy is optional from the point of view of the code, some Azure policies can enforce their own constraints. One of these is the `ALZ-Subnets Should Have a Network Security Group` policy, and this prevents the use of the standard `azurerm` provider to provision subnets - `azurerm` creates the subnet, NSG and the association separately, and so the subnet creation can't succeed without the NSG. To work around this, the `azapi` provider can be used, since this supports the subnet and NSG creation with the policy in place.

Each Subnet's Network Security Group can either be defined within the subnet object such that it is provisioned at the same time, or can pre-exist and have its Id associated when the subnet is created. Each NSG's rules that can also be defined and created within the NSG object.

Route Tables can also be defined within the subnet object, or can pre-exist and be associated with a subnet by providing its Id.

## Providers

The module supports the use of the following providers:-

- `azurerm`: the default, which can provision all resources
- `azapi`: can be used to provision `subnet` or `virtual_network_peering` resources

## Resources

The module supports the creation of the following resources:-

- `azurerm_virtual_network`
- `azurerm_network_security_group`
- `azurerm_network_security_rule`
- `azurerm_subnet_network_security_group_association`
- `azurerm_route_table`
- `azurerm_route`
- `azurerm_subnet_route_table_association`
- `azurerm_virtual_network_dns_servers`
- `azurerm_virtual_network_peering`

## Properties
The module supports the setting of the following properties:-

### Required
- `name`
- `location`
- `resource_group_name`
- `resource_group_location`
- `address_space`
- `route_table` *with properties:-*
    - `name`
    - `disable_bgp_route_propagation` *optional*
    - `routes` *optional, with properties:-*
        - `name`
        - `address_prefix` *optional*
        - `next_hop_type` *optional*
- `subnets` *with properties:-*
    - `name`
    - `address_prefixes`
    - `bastion_host` *optional, with properties:-*
        - `name`
        NOTE: Bastion Hosts can only be deployed to subnets named `AzureBastionSubnet`
    - `delegation` *optional, with properties:-*
        - `name` *optional*
        - `service_delegation` *optional with properties:-*
          - `name` *optional*
          - `actions` *optional*
    - `firewall` *optional, with properties:-*
        - `name`
        - `sku_name`
        - `sku_tier`
        **NOTE**: Firewalls can only be deployed to subnets named `AzureFirewallSubnet`
    - `associate_with_default_firewall` *optional, defaulting to `true`*
    - `nsgs` *optional, with properties:-*
        - `name`
        - `mandatory_rules_config` *with properties:-*
          - `bastion_host_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          - `ansible_linux_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          -  `ansible_windows_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          - `sophos_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          - `rapid7_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          - `snare_udp_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
          - `snare_tcp_rule_config` *with properties:-*
            - `source_ip`
            - `destination_ip`
        - `rules` *optional, with properties:-*
            - `name`
            - `priority`
            - `direction`
            - `access`
            - `protocol`
            - `source_port_range`
            - `destination_port_range`
            - `source_address_prefix`
            - `destination_prefix_address`
        **NOTE**: an `nsg` should not be created for subnets called `AzureFirewallSubnet` or `AzureBastionSubnet`
    - `nsg_ids` *optional*
    - `private_endpoint_network_policies_enabled` *optional*
    - `private_link_service_network_policies_enabled` *optional*
    - `route_table_ids` *optional*
    - `service_endpoints` *optional*
    - `service_endpoint_policy_ids` *optional*

### Optional
- `dns_servers`
- `ddos_protection_plan`
- `edge_zone`
- `flow_timeout_in_minutes`
- `peering` *with properties:-*
    - `remote_virtual_network_name`
    - `remote_virtual_network_resource_group_name` *optional, defaulting to Virtual Network's Resource Group*

## Outputs
The module outputs the following values:-

- Virtual Network Id
- Name
- Subnets
- Peerings