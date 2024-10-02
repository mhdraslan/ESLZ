targetScope = 'resourceGroup'

param routeTableConfig object = {
  name:'udr01'
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

resource routeTable 'Microsoft.Network/routeTables@2024-01-01' = {
  name: routeTableConfig.name
  location: resourceGroup().location
  properties:{
    routes: routeTableConfig.routes
  }
  tags: routeTableConfig.tags
}
