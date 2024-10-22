targetScope = 'resourceGroup'

param virtualNetworkConfig object = {
  name:'virtualnetwork1'
  resourceGroup: 'isys-aen-network-rg'
  addressPrefixes : ['192.168.0.0/24','192.168.1.0/24']
  dnsServers: ['192.168.0.4','192.168.1.4']
  subnets: [
    {
      name: 'az-subnet-x-001'
      addressPrefix: '192.168.0.0/26'
      networkSecurityGroupName: ''
      networkSecurityGroupResourceGroupName: ''
      routeTableName: ''
      routeTableResourceGroupName: ''
    }
  ]
  tags: {
    'cost center': '1234'
  }
}


resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkConfig.name
  location: resourceGroup().location
  properties:{
    addressSpace: {
      addressPrefixes:virtualNetworkConfig.addressPrefixes
    }
    dhcpOptions: {
      dnsServers: virtualNetworkConfig.dnsServers
    }
    subnets:[
      for subnet in virtualNetworkConfig.subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: empty(subnet.networkSecurityGroupName) ? null : {
            id: resourceId(subnet.networkSecurityGroupResourceGroupName,'Microsoft.Network/networkSecurityGroups',subnet.networkSecurityGroupName)
          }
          routeTable: empty(subnet.routeTableName) ? null : {
            id: resourceId(subnet.routeTableResourceGroupName,'Microsoft.Network/routeTables',subnet.routeTableName)
          }
        }
      }
    ]
  }
  tags: virtualNetworkConfig.tags
}
