
targetScope = 'subscription'

param routeTables array

param networkSecurityGroups array

param virtualNetworks array


module createRouteTables '../3.templates/networking/udr.bicep' = [for udr in routeTables: {
  name: udr.name
  scope: resourceGroup(udr.resourceGroup)
  params: {
    routeTableConfig: udr
  }
}]

module createNetworkSecurityGroups '../3.templates/networking/nsg.bicep' = [for nsg in networkSecurityGroups: {
  name: 'Create-NSG-${nsg.name}'
  scope: resourceGroup(nsg.resourceGroup)
  params: {
    networkSecurityGroupConfig: nsg
  }
}]

module createVirtualNetworks '../3.templates/networking/virtual-network.bicep'= [for vnet in virtualNetworks: {
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

