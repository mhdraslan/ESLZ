targetScope = 'resourceGroup'

param logAnalyticsWorkspaceConfig object = {
  name: 'mylaw'
  resourceGroup: 'rg1'
  defaultDataCollectionRuleResourceId: ''
  publicNetworkAccessForIngestion: 'Enabled'
  publicNetworkAccessForQuery: 'Enabled'
  tags: {
    'Cost Center': '1234'
  }
}

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  location: resourceGroup().location
  name: logAnalyticsWorkspaceConfig.name
  properties:{
    defaultDataCollectionRuleResourceId: empty(logAnalyticsWorkspaceConfig.defaultDataCollectionRuleResourceId) ? null : logAnalyticsWorkspaceConfig.defaultDataCollectionRuleResourceId
    publicNetworkAccessForIngestion: logAnalyticsWorkspaceConfig.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: logAnalyticsWorkspaceConfig.publicNetworkAccessForQuery
  }
  tags: logAnalyticsWorkspaceConfig.tags
}
