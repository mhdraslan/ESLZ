
targetScope = 'subscription'

param logAnalyticsWorkspaces array

module createLogAnalyticsWorkspaces 'br/public:avm/res/operational-insights/workspace:0.12.0' = [for ws in logAnalyticsWorkspaces: if (ws.deploy) {
  name: 'Create-LAWorkspace-${ws.name}'
  scope: resourceGroup(ws.resourceGroup)
  params: {
    name: ws.name
    publicNetworkAccessForIngestion: ws.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: ws.publicNetworkAccessForQuery
    tags: ws.tags
  }
}]
