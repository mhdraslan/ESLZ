
targetScope = 'subscription'

param logAnalyticsWorkspaces array

module createLogAnalyticsWorkspaces '../3.templates/monitor/law.bicep' = [for ws in logAnalyticsWorkspaces: if (ws.deploy) {
  name: 'Create-Monitoring-${ws.name}'
  scope: resourceGroup(ws.resourceGroup)
  params: {
    logAnalyticsWorkspaceConfig: ws
  }
}]
