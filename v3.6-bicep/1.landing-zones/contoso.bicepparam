using './lz.bicep'

param lzName = 'Contoso'

param subscriptionId = '5fe2c881-8871-4546-bc4e-07a2e40dbe9e'

param resourceGroups = [
  {
    deploy: true
    name: 'isys-aen-hub-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    deploy: true
    name: 'isys-aen-monitor-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    deploy: true
    name: 'isys-aen-recovery-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    deploy: true
    name: 'isys-aen-security-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    deploy: false
    name: 'isys-aen-app01-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
]

param routeTables = [
  {
    deploy: true
    name:'isys-aen-spoke-udr'
    resourceGroup: 'isys-aen-hub-rg'
    routes: [
      {
        name: 'default-route'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.0.0.4'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
    tags: {}
  }

]

param networkSecurityGroups = [
  {
    deploy: true
    name:'isys-aen-hub-shared-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    deploy: true
    name:'isys-aen-hub-appgw-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    deploy: true
    name:'isys-aen-hub-pe-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    deploy: false
    name:'isys-aen-app01-web-nsg'
    resourceGroup: 'isys-aen-app01-rg'
    securityRules: []
    tags: {}
  }
  {
    deploy: false
    name:'isys-aen-app01-db-nsg'
    resourceGroup: 'isys-aen-app01-rg'
    securityRules: []
    tags: {}
  }
]

param virtualNetworks = [
  {
    deploy: true
    name:'isys-aen-hub-vnet'
    resourceGroup: 'isys-aen-hub-rg'
    addressPrefixes : ['10.0.0.0/24','10.0.1.0/24','10.0.2.0/24']
    dnsServers: []
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: '10.0.0.0/26'
        networkSecurityGroupName: ''
        networkSecurityGroupResourceGroupName: ''
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'AzureFirewallManagementSubnet'
        addressPrefix: '10.0.0.64/26'
        networkSecurityGroupName: ''
        networkSecurityGroupResourceGroupName: ''
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: '10.0.0.128/26'
        networkSecurityGroupName: ''
        networkSecurityGroupResourceGroupName: ''
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.0.192/26'
        networkSecurityGroupName: ''
        networkSecurityGroupResourceGroupName: ''
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'AppGatewaySubnet'
        addressPrefix: '10.0.1.0/26'
        networkSecurityGroupName: 'isys-aen-hub-appgw-nsg'
        networkSecurityGroupResourceGroupName: 'isys-aen-hub-rg'
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'PrivateEndpointSubnet'
        addressPrefix: '10.0.1.64/26'
        networkSecurityGroupName: 'isys-aen-hub-pe-nsg'
        networkSecurityGroupResourceGroupName: 'isys-aen-hub-rg'
        routeTableName: ''
        routeTableResourceGroupName: ''
      }      
      {
        name: 'SharedServicesSubnet'
        addressPrefix: '10.0.1.128/26'
        networkSecurityGroupName: 'isys-aen-hub-shared-nsg'
        networkSecurityGroupResourceGroupName: 'isys-aen-hub-rg'
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'Reserved01Subnet'
        addressPrefix: '10.0.1.192/26'
        networkSecurityGroupName: ''
        networkSecurityGroupResourceGroupName: ''
        routeTableName: ''
        routeTableResourceGroupName: ''
      }      
    ]
    tags: {}
  }
  {
    deploy: false
    name:'isys-aen-app01-vnet'
    resourceGroup: 'isys-aen-app01-rg'
    addressPrefixes : ['10.0.4.0/24']
    dnsServers: []
    subnets: [
      {
        name: 'WebTierSubnet'
        addressPrefix: '10.0.4.0/26'
        networkSecurityGroupName: 'isys-aen-app01-web-nsg'
        networkSecurityGroupResourceGroupName: 'isys-aen-app01-rg'
        routeTableName: 'isys-aen-spoke-udr'
        routeTableResourceGroupName: 'isys-aen-hub-rg'
      }
      {
        name: 'DbTierSubnet'
        addressPrefix: '10.0.4.64/26'
        networkSecurityGroupName: 'isys-aen-app01-db-nsg'
        networkSecurityGroupResourceGroupName: 'isys-aen-app01-rg'
        routeTableName: 'isys-aen-spoke-udr'
        routeTableResourceGroupName: 'isys-aen-hub-rg'
      }
    ]
    tags: {}
  }
]

param logAnalyticsWorkspaces = [
  {
    deploy: true
    name: 'isys-aen-monitor-ops-logaws'
    resourceGroup: 'isys-aen-monitor-rg'
    defaultDataCollectionRuleResourceId: ''
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    tags: {
      'Cost Center': '1234'
    }
  }
  {
    deploy: true
    name: 'isys-aen-monitor-sec-logaws'
    resourceGroup: 'isys-aen-security-rg'
    defaultDataCollectionRuleResourceId: ''
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    tags: {
      'Cost Center': '1234'
    }
  }  
]

param backupVaults = [
  {
    deploy: true
    name: 'isys-aen-recovery-default-bv'
    resourceGroup: 'isys-aen-recovery-rg'
    alertsForAllJobFailures: 'Enabled'
    immutabilityState: 'Disabled' // Allowed values: 'Disabled' 'Locked' 'Unlocked'
    softDeleteState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
    retentionDurationInDays: 30
    datastoreType: 'ArchiveStore' // Allowed values: 'ArchiveStore' 'SnapshotStore' 'VaultStore'
    vaultType: 'LocallyRedundant' // Allowed values: 'GeoRedundant' 'LocallyRedundant' 'ZoneRedundant'
    tags:{
      'Cost Center': '1234'
    }
  }
]

param recoveryServiceVaults = [
  {
    deploy: true
    name: 'isys-aen-recovery-default-rsv'
    resourceGroup: 'isys-aen-recovery-rg'
    skuName: 'Standard' // Allowed values: Standard
    alertsForAllFailoverIssues: 'Enabled'
    alertsForAllJobFailures: 'Enabled'
    alertsForAllReplicationIssues: 'Enabled'
    alertsForCriticalOperations: 'Enabled'
    emailNotificationsForSiteRecovery: 'Enabled'
    publicNetworkAccess: 'Enabled'
    crossRegionRestore: 'Disabled'
    standardTierStorageRedundancy: 'LocallyRedundant' // Allowed values: 'GeoRedundant' 'Invalid' 'LocallyRedundant' 'ZoneRedundant'
    crossSubscriptionRestoreState: 'Disabled' // Allowed values: 'Disabled' 'Enabled' 'PermanentlyDisabled'
    immutabilityState: 'Disabled' // Allowed values: 'Disabled' 'Locked' 'Unlocked'
    enhancedSecurityState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
    softDeleteState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
    softDeleteRetentionPeriodInDays: 30
    tags:{
      'Cost Center': '1234'
    }
  }
]
