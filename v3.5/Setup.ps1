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
$Deploymentlocation = "eastus"
$environmentName = "CloudNXG" # Only upper and lower characters and space
$TemplateBaseUri = "https://raw.githubusercontent.com/mhdraslan/ESLZ/main/Working"
#endregion

# Record start time
$Now = Get-Date
[datetime]$Start = $Now
Write-Host "Starting operation at $Now" -ForegroundColor Yellow -BackgroundColor Black

# Start the deployment
Write-Host "Initiating deployment..." -ForegroundColor Yellow -BackgroundColor Black
$DeploymentName = $environmentName + " -Environment-Deployment-" + $Now.ToString("yyyyMMddHHmmss")
$MainTemplateUri = $TemplateBaseUri + "/main.json"
$MainParamsUri = $TemplateBaseUri + "/main.param.json"
$rgDeployment = New-AzSubscriptionDeployment -Name $DeploymentName.Replace(" ","") -location $Deploymentlocation -TemplateUri $MainTemplateUri -TemplateParameterUri $MainParamsUri -verbose
$rgDeployment.Outputs.rgName.Value

# Record stop time and report deployment status
$Now = Get-Date
[datetime]$Finish = Get-Date
Write-Host "Operation completed at $Now" -ForegroundColor Yellow -BackgroundColor Black

$Total = $Finish - $Start
$Total


<#
   New-AzManagementGroupDeployment -Name "test001" -ManagementGroupId "IntelliSYS" -Location uaenorth -TemplateUri "https://raw.githubusercontent.com/mhdraslan/ESLZ/main/v3.0/Master/main.json" -TemplateParameterFile "C:\Users\mraslan\OneDrive\Documents\GitHub\ESLZ\v3.0\Master\main.param.json"
#>

