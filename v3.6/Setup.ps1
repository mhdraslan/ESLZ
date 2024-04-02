<# 
 .SYNOPSIS 
    Build Azure Environment using pre-defined ARM templates 
 .DESCRIPTION 
    This script is launcher for a series of ARM templates which will build predefined set of resource groups, 
    virtual networks, VPN gateway and connections, and number of virtual machines.
 .NOTES 
    Author  : Muhammad Raslan (mraslan@microsoft.com) 
    Requires: Az Module
#>


#region Global Variables
$deploymentLocation = "UAENorth"
$environmentName = "IntelliSYS" # Only upper and lower characters and space
$templateBaseUri = "https://raw.githubusercontent.com/mhdraslan/ESLZ/main/"
#endregion

#region Deployment Variables
$deploymentType = "Tenant" # Allowed values: RG, Sub, MG, Tenant
$deploymentManagementGroup = "" # Used only for Management Group ID for management group deployments.
$deploymentName = $environmentName + " -Environment-Deployment-" + $Now.ToString("yyyy-MM-dd-HH:mm:ss")
$mainTemplateUri = $TemplateBaseUri + "v3.6/Master/main.json"
$mainParamsUri = $TemplateBaseUri + "v3.6/Master/main.param.json"
#endregion

# Record start time
$Now = Get-Date
[datetime]$Start = $Now
Write-Host "Starting operation at $Now" -ForegroundColor Yellow -BackgroundColor Black


# Subscription Deployment
if($deploymentType.ToLower() -eq "sub") {
   Write-Host "Initiating tenant deployment..." -ForegroundColor Yellow -BackgroundColor Black
   $deploymentResult = New-AzSubscriptionDeployment -Name $deploymentName.Replace(" ","") -location $deploymentLocation -TemplateUri $mainTemplateUri -TemplateParameterUri $mainParamsUri -verbose
   $deploymentResult.Outputs.rgName.Value
}

# Management Group Deployment
if($deploymentType.ToLower() -eq "mg") {
   Write-Host "Initiating management group deployment..." -ForegroundColor Yellow -BackgroundColor Black
   $deploymentResult = New-AzManagementGroupDeployment -Name $deploymentName.Replace(" ","") -ManagementGroupId $deploymentManagementGroup -Location $deploymentLocation -TemplateUri $mainTemplateUri -TemplateParameterUri $mainParamsUri -verbose
   $deploymentResult.Outputs.rgName.Value
}

# Azure Tenant Deployment
if($deploymentType.ToLower() -eq "mg") {
   Write-Host "Initiating tenant deployment..." -ForegroundColor Yellow -BackgroundColor Black
   $deploymentResult = New-AzTenantDeployment -Name $deploymentName.Replace(" ","") -Location $deploymentLocation -TemplateUri $mainTemplateUri -TemplateParameterUri $mainParamsUri -verbose
   $deploymentResult.Outputs.rgName.Value
}

# Record stop time and report deployment status
$Now = Get-Date
[datetime]$Finish = Get-Date
Write-Host "Operation completed at $Now" -ForegroundColor Yellow -BackgroundColor Black

$Total = $Finish - $Start
$Total
