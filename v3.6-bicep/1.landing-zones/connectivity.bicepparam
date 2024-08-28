using './lz.bicep'

param lzName = 'Connectivity'

param subscriptionId = '67236ec4-f453-4086-b4d1-78a6a93fad71'

param resourceGroups = [
  {
    name: 'isys-aen-network-rg'
    location: 'uaenorth'
    lock: {
      kind: 'CanNotDelete'
      name: 'nodelete-lock'
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
]

param routeTables = [
  {
    name:'isys-aen-connectivity-01-udr'
    resourceGroup: 'isys-aen-network-rg'
    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '172.16.0.20'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
    tags: {
      'cost center': '1234'
    }
  }
]

param networkSecurityGroups = [
  {
    name:'isys-aen-sharedservices-01-nsg'
    resourceGroup: 'isys-aen-network-rg'
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
    tags: {
      'cost center': '1234'
    }
  }
]

param virtualNetworks = [
  {
    name:'virtualnetwork1'
    resourceGroup: 'isys-aen-network-rg'
    addressPrefixes : ['10.0.0.0/24','10.0.1.0/24']
    dnsServers: ['10.0.0.4','10.0.1.4']
    subnets: [
      {
        name: 'subnet-001'
        addressPrefix: '10.0.0.0/26'
        networkSecurityGroupResourceId: 'isys-aen-sharedservices-01-nsg'
        routeTableResourceId: 'isys-aen-connectivity-01-udr'
      }      
    ]
    tags: {
      'cost center': '205020'
    }
  }
]

