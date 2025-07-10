
targetScope = 'subscription'

param routeTables array

param networkSecurityGroups array

param virtualNetworks array


module createRouteTables 'br/public:avm/res/network/route-table:0.4.1' = [for udr in routeTables: if(udr.deploy) {
  name: 'Create-UDR-${udr.name}'
  scope: resourceGroup(udr.resourceGroup)
  params: {
    name: udr.name
    routes: udr.routes
    tags: udr.tags
  }
}]

module createNetworkSecurityGroups 'br/public:avm/res/network/network-security-group:0.5.1' = [for nsg in networkSecurityGroups: if(nsg.deploy) {
  name: 'Create-NSG-${nsg.name}'
  scope: resourceGroup(nsg.resourceGroup)
  params: {
    name: nsg.name
    securityRules: nsg.securityRules
    tags: nsg.tags
  }
}]

module createVirtualNetworks 'br/public:avm/res/network/virtual-network:0.7.0'= [for vnet in virtualNetworks: if(vnet.deploy) {
  name: 'Create-Virtual-Networks-${vnet.name}'
  scope: resourceGroup(vnet.resourceGroup)
  dependsOn: [
    createRouteTables
    createNetworkSecurityGroups
  ]
  params: {
    name: vnet.name
    addressPrefixes: vnet.addressPrefixes
    subnets: vnet.subnets
    dnsServers: vnet.dnsServers
    tags: vnet.tags
  }
}]

