using './lz.bicep'

param lzName = 'Contoso'

param subscriptionId = '5731edc2-4c5d-4a45-a342-331636ebe081'

param resourceGroups = [
  {
    name: 'cnt-aen-hub-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'cnt-aen-monitor-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'cnt-aen-recovery-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'cnt-aen-security-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'cnt-aen-app01-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
]

param routeTables = [
  {
    name:'cnt-aen-spoke-udr'
    resourceGroup: 'cnt-aen-hub-rg'
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
    name:'cnt-aen-hub-shared-nsg'
    resourceGroup: 'cnt-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'cnt-aen-hub-appgw-nsg'
    resourceGroup: 'cnt-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'cnt-aen-hub-pe-nsg'
    resourceGroup: 'cnt-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'cnt-aen-app01-web-nsg'
    resourceGroup: 'cnt-aen-app01-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'cnt-aen-app01-db-nsg'
    resourceGroup: 'cnt-aen-app01-rg'
    securityRules: []
    tags: {}
  }
]

param virtualNetworks = [
  {
    name:'vnet-hub'
    resourceGroup: 'cnt-aen-hub-rg'
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
        networkSecurityGroupName: 'cnt-aen-hub-appgw-nsg'
        networkSecurityGroupResourceGroupName: 'cnt-aen-hub-rg'
        routeTableName: ''
        routeTableResourceGroupName: ''
      }
      {
        name: 'PrivateEndpointSubnet'
        addressPrefix: '10.0.1.64/26'
        networkSecurityGroupName: 'cnt-aen-hub-pe-nsg'
        networkSecurityGroupResourceGroupName: 'cnt-aen-hub-rg'
        routeTableName: ''
        routeTableResourceGroupName: ''
      }      
      {
        name: 'SharedSubnet'
        addressPrefix: '10.0.1.128/26'
        networkSecurityGroupName: 'cnt-aen-hub-shared-nsg'
        networkSecurityGroupResourceGroupName: 'cnt-aen-hub-rg'
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
    name:'vnet-app01'
    resourceGroup: 'cnt-aen-app01-rg'
    addressPrefixes : ['10.0.4.0/24']
    dnsServers: []
    subnets: [
      {
        name: 'WebTierSubnet'
        addressPrefix: '10.0.4.0/26'
        networkSecurityGroupName: 'cnt-aen-app01-web-nsg'
        networkSecurityGroupResourceGroupName: 'cnt-aen-app01-rg'
        routeTableName: 'cnt-aen-spoke-udr'
        routeTableResourceGroupName: 'cnt-aen-hub-rg'
      }
      {
        name: 'DbTierSubnet'
        addressPrefix: '10.0.4.64/26'
        networkSecurityGroupName: 'cnt-aen-app01-db-nsg'
        networkSecurityGroupResourceGroupName: 'cnt-aen-app01-rg'
        routeTableName: 'cnt-aen-spoke-udr'
        routeTableResourceGroupName: 'cnt-aen-hub-rg'
      }
    ]
    tags: {}
  }
]
