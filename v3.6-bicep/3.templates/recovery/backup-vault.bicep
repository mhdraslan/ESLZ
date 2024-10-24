targetScope = 'resourceGroup'

param backupVaultConfig object = {
  name: 'example-backup-vault'
  resourceGroup: 'example-resource-group'
  alertsForAllJobFailures: 'Enabled'
  immutabilityState: 'Disabled' // Allowed values: 'Disabled' 'Locked' 'Unlocked'
  softDeleteState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
  retentionDurationInDays: 30
  datastoreType: 'ArchiveStore' // Allowed values: 'ArchiveStore' 'SnapshotStore' 'VaultStore'
  vaultType: 'ZoneRedundant' // Allowed values: 'GeoRedundant' 'LocallyRedundant' 'ZoneRedundant'
  tags:{
    'Cost Center': '1234'
  }
}

resource resBackupVault 'Microsoft.DataProtection/backupVaults@2024-04-01' = {
  name: backupVaultConfig.name
  location: resourceGroup().location
  properties:{
    monitoringSettings:{
      azureMonitorAlertSettings:{
        alertsForAllJobFailures: backupVaultConfig.alertsForAllJobFailures
      }
    }
    securitySettings:{
      immutabilitySettings: {
        state: backupVaultConfig.immutabilityState
      }
      softDeleteSettings:{
        retentionDurationInDays: backupVaultConfig.retentionDurationInDays
        state: backupVaultConfig.softDeleteState
      }
    }
    storageSettings:[
      {
        datastoreType: backupVaultConfig.datastoreType
        type: backupVaultConfig.vaultType
      }
    ]
  }
  tags: backupVaultConfig.tags
}
