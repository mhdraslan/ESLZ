targetScope = 'subscription'

param lzName string
param subscriptionId string
param resourceGroups array
param routeTables array
param networkSecurityGroups array
param virtualNetworks array
param logAnalyticsWorkspaces array
param backupVaults array
param recoveryServiceVaults array


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

module buildLzMonitoring '../2.lz-factory/monitoring.bicep' = {
  name: 'Landing-Zone-${lzName}-Monitoring'
  dependsOn: [
    buildLzFramework
    buildLzNetworking
  ]
  scope:subscription(subscriptionId)
  params: {
    logAnalyticsWorkspaces: logAnalyticsWorkspaces
  }
}

module buildLzRecovery '../2.lz-factory/recovery.bicep' = {
  name: 'Landing-Zone-${lzName}-Recovery'
  dependsOn: [
    buildLzFramework
  ]
  scope: subscription(subscriptionId)
  params: {
    backupVaults: backupVaults
    recoveryServiceVaults: recoveryServiceVaults
  }
}

// Start deployment using the following command: New-AzSubscriptionDeployment -Name BuildLz -Location uaenorth -TemplateFile .\lz.bicep -TemplateParameterFile .\<environment>.bicepparam -Verbose 
