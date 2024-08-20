
param managementGroups array = [
    {
        id:'mg-test1'
        name:'Test MG 1'
        parent:'9def2203-d472-4e2e-af0d-19db3f40aac6'
    }
    {
        id:'mg-test2'
        name:'Test MG 2'
        parent:'9def2203-d472-4e2e-af0d-19db3f40aac6'
    }
]

targetScope = 'managementGroup'

module managementGroup 'br/public:avm/res/management/management-group:0.1.2' = [for mg in managementGroups: {
  name: '${mg}.id'
  params: {
    // Required parameters
    name: '${mg}.id'
    // Non-required parameters
    location: 'uaenorth'
  }
}]
