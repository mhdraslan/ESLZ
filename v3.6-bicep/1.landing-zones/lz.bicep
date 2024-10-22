targetScope = 'subscription'

param lzName string
param subscriptionId string
param resourceGroups array
param routeTables array
param networkSecurityGroups array
param virtualNetworks array


module buildLzFramework '../2.lz-factory/lz-framework.bicep' = {
  name: 'Landing-Zone-${lzName}-Resouce-Groups'
  scope: subscription(subscriptionId)
  params: {
    resourceGroups: resourceGroups
  }
}

module buildLzNetworking '../2.lz-factory/networking.bicep' = {
  name: 'Landing-Zone-${lzName}-Networking'
  scope: subscription(subscriptionId)
  dependsOn: [
    buildLzFramework
  ]
  params: {
    routeTables: routeTables
    networkSecurityGroups: networkSecurityGroups
    virtualNetworks: virtualNetworks
  }
}
// Start deployment using the following command: New-AzSubscriptionDeployment -Name BuildLz -Location uaenorth -TemplateFile .\lz.bicep -TemplateParameterFile .\<environment>.bicepparam -Verbose 
