using './lz.bicep'

param lzName = 'Contoso'

param subscriptionId = '5fe2c881-8871-4546-bc4e-07a2e40dbe9e'

param resourceGroups = [
  {
    name: 'isys-aen-hub-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'isys-aen-monitor-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'isys-aen-recovery-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
    name: 'isys-aen-security-rg'
    location: 'uaenorth'
    lock: {
      kind: 'None'
      name: ''
    }
  }
  {
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
    name:'isys-aen-hub-shared-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'isys-aen-hub-appgw-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'isys-aen-hub-pe-nsg'
    resourceGroup: 'isys-aen-hub-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'isys-aen-app01-web-nsg'
    resourceGroup: 'isys-aen-app01-rg'
    securityRules: []
    tags: {}
  }
  {
    name:'isys-aen-app01-db-nsg'
    resourceGroup: 'isys-aen-app01-rg'
    securityRules: []
    tags: {}
  }
]

param virtualNetworks = [
  {
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
