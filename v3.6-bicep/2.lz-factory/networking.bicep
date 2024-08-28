
targetScope = 'subscription'

param routeTables array = [
  {
    name:'udr01'
    resourceGroup: 'isys-aen-network-rg'
    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '172.16.0.20'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
    tags: {
      'cost center': '1234'
    }
  }
]

param networkSecurityGroups array = [
  {
    name:'nsg01'
    resourceGroup: 'isys-aen-network-rg'
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
    tags: {
      'cost center': '1234'
    }
  }
]

param virtualNetworks array = [
  {
    name:'virtualnetwork1'
    resourceGroup: 'isys-aen-network-rg'
    addressPrefixes : ['192.168.0.0/24','192.168.1.0/24']
    dnsServers: ['192.168.0.4','192.168.1.4']
    subnets: [
      {
        name: 'az-subnet-x-001'
        addressPrefix: '192.168.0.0/26'
        networkSecurityGroupResourceId: ''
        routeTableResourceId: ''
      }      
    ]
    tags: {
      'cost center': '1234'
    }
  }
]


module routeTable 'br/public:avm/res/network/route-table:0.3.0' = [for udr in routeTables: {
  name: udr.name
  scope: resourceGroup(udr.resourceGroup)
  params: {
    name: udr.name
    routes: udr.routes
    tags: udr.tags
  }
}]

module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.4.0' = [for nsg in networkSecurityGroups: {
  name: 'Create-NSG-${nsg.name}'
  scope: resourceGroup(nsg.resourceGroup)
  params: {
    name: nsg.name
    securityRules: nsg.securityRules
    tags: nsg.tags
  }
}]

module createVirtualNetworks 'br/public:avm/res/network/virtual-network:0.2.0' = [for vnet in virtualNetworks: {
  name: 'Create-Virtual-Network-${vnet.name}'
  scope: resourceGroup(vnet.resourceGroup)
  dependsOn: [
    networkSecurityGroup
  ]
  params: {
    name: vnet.name
    addressPrefixes:vnet.addressPrefixes
    dnsServers: vnet.dnsServers
    subnets: vnet.subnets
    tags: vnet.tags
  }
}]

