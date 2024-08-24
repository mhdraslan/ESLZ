targetScope = 'subscription'

param lzName string
param subscriptionId string
param resourceGroups array

module createResourceGroups '../2.lz-factory/lz-framework.bicep' = {
  name: 'Create-Resouce-Groups-${lzName}'
  scope: subscription(subscriptionId)
  params: {
    resourceGroups: resourceGroups
  }
}
