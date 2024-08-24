using '../2.lz-factory/lz.bicep'

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

