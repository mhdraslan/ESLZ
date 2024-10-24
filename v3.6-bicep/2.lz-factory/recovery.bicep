
targetScope = 'subscription'

param backupVaults array
param recoveryServiceVaults array

module createBackupVaults '../3.templates/recovery/backup-vault.bicep' = [for bvault in backupVaults: {
  name: 'Create-Monitoring-${bvault.name}'
  scope: resourceGroup(bvault.resourceGroup)
  params: {
    backupVaultConfig: bvault
  }
}]

module createRecoveryServiceVaults '../3.templates/recovery/recovery-vault.bicep' = [for rsv in recoveryServiceVaults:{
  scope: resourceGroup(rsv.resourceGroup)
  name: 'Create-RSV-${rsv.name}'
  params: {
    rsVaultConfig: rsv
  }
}]
