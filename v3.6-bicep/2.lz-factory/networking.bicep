
targetScope = 'subscription'

param routeTables array

param networkSecurityGroups array

param virtualNetworks array


module createRouteTables '../3.templates/networking/udr.bicep' = [for udr in routeTables: if(udr.deploy) {
  name: udr.name
  scope: resourceGroup(udr.resourceGroup)
  params: {
    routeTableConfig: udr
  }
}]

module createNetworkSecurityGroups '../3.templates/networking/nsg.bicep' = [for nsg in networkSecurityGroups: if(nsg.deploy) {
  name: 'Create-NSG-${nsg.name}'
  scope: resourceGroup(nsg.resourceGroup)
  params: {
    networkSecurityGroupConfig: nsg
  }
}]

module createVirtualNetworks '../3.templates/networking/virtual-network.bicep'= [for vnet in virtualNetworks: if(vnet.deploy) {
  name: 'Create-Virtual-Networks-${vnet.name}'
  scope: resourceGroup(vnet.resourceGroup)
  dependsOn: [
    createRouteTables
    createNetworkSecurityGroups
  ]
  params: {
    virtualNetworkConfig: vnet
  }
}]

