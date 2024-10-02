targetScope = 'resourceGroup'

param networkSecurityGroupConfig object = {
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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: networkSecurityGroupConfig.name
  location: resourceGroup().location
  properties:{
    securityRules: networkSecurityGroupConfig.securityRules
  }
  tags: networkSecurityGroupConfig.tags
}
