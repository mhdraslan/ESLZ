targetScope = 'resourceGroup'

param rsVaultConfig object = {
  name: 'example-recovery-services-vault'
  resourceGroup: 'example-resource-group'
  skuName: 'Standard' // Allowed values: Standard
  alertsForAllFailoverIssues: 'Enabled'
  alertsForAllJobFailures: 'Enabled'
  alertsForAllReplicationIssues: 'Enabled'
  alertsForCriticalOperations: 'Enabled'
  emailNotificationsForSiteRecovery: 'Enabled'
  publicNetworkAccess: 'Enabled'
  crossRegionRestore: 'Disabled'
  standardTierStorageRedundancy: 'ZoneRedundant' // Allowed values: 'GeoRedundant' 'Invalid' 'LocallyRedundant' 'ZoneRedundant'
  crossSubscriptionRestoreState: 'Disabled' // Allowed values: 'Disabled' 'Enabled' 'PermanentlyDisabled'
  immutabilityState: 'Disabled' // Allowed values: 'Disabled' 'Locked' 'Unlocked'
  enhancedSecurityState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
  softDeleteState: 'AlwaysON' //Allowed values: 'AlwaysON' 'Disabled' 'Enabled' 'Invalid'
  softDeleteRetentionPeriodInDays: 30
  tags:{
    'Cost Center': '1234'
  }
}

resource resRecoveryServiceVault 'Microsoft.RecoveryServices/vaults@2024-04-01' = {
  name: rsVaultConfig.name
  location: resourceGroup().location
  sku:{
    name: rsVaultConfig.skuName
  }
  properties:{
    monitoringSettings:{
      azureMonitorAlertSettings:{
        alertsForAllFailoverIssues:rsVaultConfig.alertsForAllFailoverIssues
        alertsForAllJobFailures: rsVaultConfig.alertsForAllJobFailures
        alertsForAllReplicationIssues: rsVaultConfig.alertsForAllReplicationIssues
      }
      classicAlertSettings:{
        alertsForCriticalOperations: rsVaultConfig.alertsForCriticalOperations
        emailNotificationsForSiteRecovery: rsVaultConfig.emailNotificationsForSiteRecovery
      }
    }
    publicNetworkAccess: rsVaultConfig.publicNetworkAccess
    redundancySettings:{
      crossRegionRestore: rsVaultConfig.crossRegionRestore
      standardTierStorageRedundancy: rsVaultConfig.standardTierStorageRedundancy
    }
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: rsVaultConfig.crossSubscriptionRestoreState
      }
    }
    securitySettings:{
      immutabilitySettings: {
        state: rsVaultConfig.immutabilityState
      }
      softDeleteSettings:{
        enhancedSecurityState: rsVaultConfig.enhancedSecurityState
        softDeleteRetentionPeriodInDays: rsVaultConfig.softDeleteRetentionPeriodInDays
        softDeleteState: rsVaultConfig.softDeleteState
      }
    }
  }
  tags: rsVaultConfig.tags
}
