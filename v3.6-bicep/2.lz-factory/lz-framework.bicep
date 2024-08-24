targetScope = 'subscription'

param resourceGroups array

module createResourceGroups 'br/public:avm/res/resources/resource-group:0.3.0' = [for rg in resourceGroups:{
  name: 'CreateResourceGroup-${rg.name}'
  params: {
    name: rg.name
    location:rg.location
    lock: rg.lock
  }
}]
